import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class TrackingControls extends GetView<HomeController> {
  const TrackingControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => ElevatedButton.icon(
                  onPressed: controller.isTracking.value ? null : controller.handleStart,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("START"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                )),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(() => ElevatedButton.icon(
                  onPressed: controller.isTracking.value ? controller.handleStop : null,
                  icon: const Icon(Icons.stop),
                  label: const Text("STOP"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
