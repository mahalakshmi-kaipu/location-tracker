import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(
    GetMaterialApp(
      title: "GPS Tracker",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
    ),
  );
}
