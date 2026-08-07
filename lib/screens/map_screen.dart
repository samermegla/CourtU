import 'package:flutter/material.dart';
// geolocator and mapbox both export a `Position`. Prefix geolocator's so we can
// name it (geo.Position) without clashing with Mapbox's Position.
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../config/mapbox_config.dart';
import '../services/geolocation_service.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GeolocationService _geolocation = const GeolocationService();


  static final Point _fallbackCenter =
      Point(coordinates: Position(-96.7502, 32.9857));

  Point _center = _fallbackCenter;


  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    final lastKnown = await _geolocation.getLastKnownLocation();
    if (!mounted) return;
    if (lastKnown != null) {
      setState(() {
        _center = _pointFrom(lastKnown);
        _loading = false; 
      });
    }


    try {
      final position = await _geolocation.getCurrentLocation();
      if (!mounted) return;
      setState(() {
        _center = _pointFrom(position);
        _loading = false;
      });
    } on LocationException catch (e) {
      debugPrint('Could not get user location: ${e.message}');
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Point _pointFrom(geo.Position position) => Point(
        coordinates: Position(position.longitude, position.latitude),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: SpinKitCubeGrid(
            color: Colors.white,
            size: 35.0,
          ),
        ),
      );
    }

    return Scaffold(
      body: MapWidget(
        styleUri: MapboxConfig.styleUri,
        viewport: CameraViewportState(
          center: _center,
          zoom: 12.0,
        ),
      ),
    );
  }
}
