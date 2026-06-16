import '../models/location_model.dart';
import '../providers/local_storage_provider.dart';

class LocationRepository {
  final LocalStorageProvider storageProvider;

  LocationRepository({required this.storageProvider});

  Future<int> saveLocation(LocationModel location) => storageProvider.insertLocation(location);

  Future<List<LocationModel>> getHistory() => storageProvider.getAllLocations();

  Future<void> clearHistory() => storageProvider.clearAllLocations();

  Future<void> setTracking(bool status) => storageProvider.setTrackingState(status);

  Future<bool> isTrackingEnabled() => storageProvider.getTrackingState();
}
