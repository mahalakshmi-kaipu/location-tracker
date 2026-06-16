import 'package:get/get.dart';
import 'package:location_tracker/app/data/providers/local_storage_provider.dart';
import 'package:location_tracker/app/data/repositories/location_repository.dart';
import '../controllers/home_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalStorageProvider>(() => LocalStorageProvider());
    Get.lazyPut<LocationRepository>(() => LocationRepository(storageProvider: Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(repository: Get.find()));
  }
}
