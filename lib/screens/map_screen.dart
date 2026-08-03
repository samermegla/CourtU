import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../config/mapbox_config.dart';

/// Full-screen map that renders your friend's public Mapbox style.
///
/// The access token is set once at startup (see main.dart), so here we only
/// need to point the [MapWidget] at the style URI and give it a starting
/// camera.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        styleUri: MapboxConfig.styleUri,
        viewport: CameraViewportState(

          center: Point(coordinates: Position(-0.1276, 51.5072)),
          zoom: 12.0,
        ),
      ),
    );
  }
}
