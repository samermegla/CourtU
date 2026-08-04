import 'package:geolocator/geolocator.dart';

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);

  @override
  String toString() => 'LocationException: $message';
}

class GeolocationService {
  final LocationAccuracy accuracy;

  const GeolocationService({this.accuracy = LocationAccuracy.high});

  Future<void> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        'Location services are disabled. Please enable them in settings.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationException('Location permission was denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission is permanently denied. Please enable it in '
        'your device settings.',
      );
    }
  }

 
  Future<Position> getCurrentLocation() async {
    await ensurePermission();
    return Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: accuracy),
    );
  }

  
  Future<Position?> getLastKnownLocation() {
    return Geolocator.getLastKnownPosition();
  }

  Stream<Position> locationStream({int distanceFilter = 10}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }
}
