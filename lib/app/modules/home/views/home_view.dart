import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_tracker/app/modules/home/views/delete_confirm_dialog.dart';
import 'package:location_tracker/app/modules/home/views/location_list_header.dart';
import '../controllers/home_controller.dart';
import 'info_card.dart';
import 'tracking_controls.dart';

import 'location_list.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Location Tracker'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshAll,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => DeleteConfirmDialog.show(),
          ),
        ],
      ),
      body: const Column(
        children: [
          InfoCard(),
          TrackingControls(),
          Divider(),
          LocationListHeader(),
          Expanded(child: LocationList()),
        ],
      ),
    );
  }
}
