class LocationModel {
  final int? id;
  final double latitude;
  final double longitude;
  final String timestamp;
  final double accuracy;

  LocationModel({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.accuracy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
      'accuracy': accuracy,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: json['timestamp'],
      accuracy: json['accuracy'],
    );
  }
}
