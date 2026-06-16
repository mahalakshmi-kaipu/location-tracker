import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_tracker/app/modules/home/controllers/home_controller.dart';


class DeleteConfirmDialog extends GetView<HomeController> {
  const DeleteConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Clear History"),
      content: const Text("Delete all records?"),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        TextButton(
          onPressed: () {
            controller.clearHistory();
            Get.back();
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  static void show() {
    Get.dialog(const DeleteConfirmDialog());
  }
}
