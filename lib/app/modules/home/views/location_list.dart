import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';

class LocationList extends GetView<HomeController> {
  const LocationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.locationHistory.isEmpty) {
        return const Center(child: Text("No locations recorded yet."));
      }
      return ListView.builder(
        itemCount: controller.locationHistory.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final loc = controller.locationHistory[index];
          final time = DateFormat('HH:mm:ss').format(DateTime.parse(loc.timestamp));
          return Card(
            child: ListTile(
              leading: const Icon(Icons.my_location, color: Colors.indigo),
              title: Text("Lat: ${loc.latitude.toStringAsFixed(5)}, Lng: ${loc.longitude.toStringAsFixed(5)}"),
              subtitle: Text("Time: $time | Acc: ${loc.accuracy.toStringAsFixed(1)}m"),
            ),
          );
        },
      );
    });
  }
}
