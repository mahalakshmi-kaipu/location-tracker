import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_tracker/app/modules/home/controllers/home_controller.dart';

class LocationListHeader extends GetView<HomeController> {
  const LocationListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.history, size: 20),
          const SizedBox(width: 8),
          Obx(() => Text(
                "History (${controller.locationHistory.length})",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
