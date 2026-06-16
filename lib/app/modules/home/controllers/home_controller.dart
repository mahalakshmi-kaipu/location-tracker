import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracker/app/data/models/location_model.dart';
import 'package:location_tracker/app/data/repositories/location_repository.dart';
import 'package:permission_handler/permission_handler.dart';


class HomeController extends GetxController {
  final LocationRepository repository;
  HomeController({required this.repository});

  static const platform = MethodChannel('gft.location_tracker/battery');

  var batteryLevel = "...".obs;
  var isTracking = false.obs;
  var statusMessage = "Ready".obs;
  var locationHistory = <LocationModel>[].obs;

  Timer? _uiUpdateTimer;

  @override
  void onInit() {
    super.onInit();
    refreshAll();
    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) => refreshAll());
    
    FlutterBackgroundService().on('update').listen((event) {
      loadHistory();
      statusMessage.value = "Updated at ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
    });
  }

  @override
  void onClose() {
    _uiUpdateTimer?.cancel();
    super.onClose();
  }

  void refreshAll() {
    getBattery();
    checkTrackingStatus();
    loadHistory();
  }

  Future<void> getBattery() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel.value = "$result%";
    } catch (e) {
      batteryLevel.value = "N/A";
    }
  }

  Future<void> checkTrackingStatus() async {
    isTracking.value = await repository.isTrackingEnabled();
  }

  Future<void> loadHistory() async {
    locationHistory.value = await repository.getHistory();
  }

  Future<void> clearHistory() async {
    await repository.clearHistory();
    loadHistory();
  }

  Future<void> handleStart() async {
    statusMessage.value = "Checking permissions...";
    
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Please enable GPS Services");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", "Location permission denied");
        return;
      }
    }

    statusMessage.value = "Starting service...";
    await repository.setTracking(true);
    
    final service = FlutterBackgroundService();
    await service.startService();
    service.invoke('startTracking');

    isTracking.value = true;
    statusMessage.value = "Tracking Started";
  }

  Future<void> handleStop() async {
    await repository.setTracking(false);
    FlutterBackgroundService().invoke('stopTracking');
    isTracking.value = false;
    statusMessage.value = "Stopped";
  }
}
