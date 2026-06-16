import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class InfoCard extends GetView<HomeController> {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Battery Level:", style: TextStyle(fontSize: 18)),
                Obx(() => Text(
                      controller.batteryLevel.value,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => Text("Status: ${controller.statusMessage.value}", style: const TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}
