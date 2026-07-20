import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Standalone map screen centered on UT Dallas, at a zoom level that frames
/// roughly the whole campus. Not wired into app navigation yet.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        cameraOptions: CameraOptions(
          center: Point(coordinates: Position(-96.7502, 32.9857)),
          zoom: 15,
        ),
      ),
    );
  }
}
