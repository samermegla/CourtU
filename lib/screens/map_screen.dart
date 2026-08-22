import 'package:flutter/material.dart';
// geolocator and mapbox both export a `Position`. Prefix geolocator's so we can
// name it (geo.Position) without clashing with Mapbox's Position.
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../config/mapbox_config.dart';
import '../services/geolocation_service.dart';
import '../services/court_service.dart';
import '../widgets/im_going.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GeolocationService _geolocation = const GeolocationService();
  final CourtService _courtService = CourtService();

  static final Point _fallbackCenter =
      Point(coordinates: Position(-96.7502, 32.9857));

  Point _center = _fallbackCenter;


  bool _loading = true;

  /// Draws the court dots. Created once the map is ready (see [_onMapCreated]).
  CircleAnnotationManager? _courtManager;

  /// Court data loaded from Firestore, each a plain map with id + fields.
  List<Map<String, dynamic>> _courts = [];

  /// Maps a drawn dot's annotation id back to its court, so a tap can find the
  /// court it belongs to. Rebuilt each time the dots are (re)drawn.
  final Map<String, Map<String, dynamic>> _courtByAnnotationId = {};

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _loadCourts();
  }

  Future<void> _loadUserLocation() async {
    try {
      final lastKnown = await _geolocation.getLastKnownLocation();
      if (!mounted) return;
      if (lastKnown != null) {
        setState(() {
          _center = _pointFrom(lastKnown);
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Could not get last known location: $e');
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

  /// Loads courts from Firestore. On the very first run the collection is empty,
  /// so we seed the UT Dallas court once, then read it back. After that it's
  /// read-only (no repeated writes).
  Future<void> _loadCourts() async {
    try {
      var courts = await _courtService.fetchCourts();
      if (courts.isEmpty) {
        await _courtService.seedUtDallas();
        courts = await _courtService.fetchCourts();
      }
      if (!mounted) return;
      _courts = courts;
      await _renderCourts();
    } catch (e) {
      debugPrint('Could not load courts: $e');
    }
  }

  /// Mapbox hands us the map controller once the platform view is ready. We use
  /// it to create the annotation manager, then draw whatever courts we have.
  Future<void> _onMapCreated(MapboxMap map) async {
    _courtManager = await map.annotations.createCircleAnnotationManager();
    _courtManager!.tapEvents(onTap: _onCourtTapped);
    await _renderCourts();
  }

  /// Opens the court's bottom sheet when its dot is tapped. Ignores taps whose
  /// annotation we don't recognise (e.g. a stale dot mid-redraw).
  void _onCourtTapped(CircleAnnotation annotation) {
    final court = _courtByAnnotationId[annotation.id];
    if (court == null || !mounted) return;
    ImGoingSheet.show(context, court: court);
  }

  /// Draws one dot per court. Guarded because the map and the Firestore fetch
  /// finish in an unpredictable order — this runs from both, and whichever
  /// completes last does the actual drawing. [deleteAll] keeps it from doubling
  /// up if both paths fire.
  Future<void> _renderCourts() async {
    final manager = _courtManager;
    if (manager == null || _courts.isEmpty) return;
    await manager.deleteAll();
    _courtByAnnotationId.clear();
    for (final court in _courts) {
      final annotation = await manager.create(
        CircleAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              (court['longitude'] as num).toDouble(),
              (court['latitude'] as num).toDouble(),
            ),
          ),
          circleRadius: 7.5,
          circleColor: 0xFFEF6C00, // orange
          circleStrokeWidth: 2.5,
          circleStrokeColor: 0xFFFFFFFF, // white outline
        ),
      );
      _courtByAnnotationId[annotation.id] = court;
    }
  }

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
        onMapCreated: _onMapCreated,
        viewport: CameraViewportState(
          center: _center,
          zoom: 12.0,
        ),
      ),
    );
  }
}
