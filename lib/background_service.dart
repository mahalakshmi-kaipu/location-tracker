import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'app/data/providers/local_storage_provider.dart';
import 'app/data/models/location_model.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'location_tracker_channel',
    'Location Tracker Service',
    description: 'This channel is used for location tracking.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'location_tracker_channel',
      initialNotificationTitle: 'Location Tracker',
      initialNotificationContent: 'GPS Tracking is ready',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
    service.setAsForegroundService();
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  final storage = LocalStorageProvider();
  Timer? trackingTimer;

  Future<void> recordLocation() async {
    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15),
        );
      } catch (e) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position != null) {
        final location = LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: DateTime.now().toIso8601String(),
          accuracy: position.accuracy,
        );

        await storage.insertLocation(location);
        
        if (service is AndroidServiceInstance) {
          service.setForegroundNotificationInfo(
            title: "GPS Tracking Active",
            content: "Last record at ${DateFormat('HH:mm:ss').format(DateTime.now())}",
          );
        }

        service.invoke('update', location.toJson());
      }
    } catch (e) {
      debugPrint("Background Isolate Error: $e");
    }
  }

  void startTrackingLoop() {
    trackingTimer?.cancel();
    recordLocation();
    trackingTimer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      await recordLocation();
    });
  }

  bool isTrackingEnabled = await storage.getTrackingState();
  if (isTrackingEnabled) {
    startTrackingLoop();
  }

  service.on('startTracking').listen((event) async {
    await storage.setTrackingState(true);
    startTrackingLoop();
  });

  service.on('stopTracking').listen((event) async {
    await storage.setTrackingState(false);
    trackingTimer?.cancel();
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Location Tracker",
        content: "Tracking is stopped",
      );
    }
  });
}
