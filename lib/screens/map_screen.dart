import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../theme/colors.dart';
import 'settings_screen.dart';

/// The two Mapbox Studio styles the map switches between.
///
/// Both render labels, but not the same ones: the dark style has road labels
/// turned off (`showRoadLabels: false`) while the light style has them on, so
/// light shows street names that dark does not. Cosmetic, and a Studio setting
/// rather than anything this code controls — worth evening out if the mismatch
/// is noticeable in use.
class MapStyles {
  MapStyles._();
  static const dark = 'mapbox://styles/pablo-nguyen/cmrqnug2m00e401s771jb658j';
  static const light = 'mapbox://styles/pablo-nguyen/cmruw2j0g006601s8ac963sm4';
}

/// A campus court shown on the map. Plain in-memory data for now — no
/// backend. Add more entries to [_courts] as courts are onboarded.
class _Court {
  final String name;
  final double lat;
  final double lng;
  const _Court({required this.name, required this.lat, required this.lng});
}

const _courts = <_Court>[
  _Court(name: 'UTD Sand Volleyball Courts', lat: 32.983313, lng: -96.74997),
];

/// Standalone map screen centered on UT Dallas, showing each court as a
/// glowing steel dot. Tapping a dot opens the venue sheet.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? _mapboxMap;

  /// Where the camera was before the last style swap. Switching light/dark
  /// rebuilds the map widget, which would otherwise snap back to the default
  /// UTD framing and lose wherever the user had panned to.
  CameraState? _lastCamera;

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    // Mapbox's terms require the logo and attribution (i) to stay visible —
    // only their position/margins are ours to adjust. Tucked into the
    // bottom-right, out of the way of future bottom sheets/nav bars.
    await mapboxMap.logo.updateSettings(
      LogoSettings(position: OrnamentPosition.BOTTOM_RIGHT, marginRight: 8, marginBottom: 8),
    );
    await mapboxMap.attribution.updateSettings(
      AttributionSettings(position: OrnamentPosition.BOTTOM_RIGHT, marginRight: 8, marginBottom: 8),
    );

    final manager = await mapboxMap.annotations.createCircleAnnotationManager();

    for (final court in _courts) {
      final geometry = Point(coordinates: Position(court.lng, court.lat));
      final markerColor = AppColors.courtMarker.toARGB32();
      // Wide, faint outer glow.
      await manager.create(
        CircleAnnotationOptions(
          geometry: geometry,
          circleRadius: 40,
          circleColor: markerColor,
          circleOpacity: 0.16,
          circleBlur: 1.6,
        ),
      );
      // Tighter, stronger inner glow — gives the halo more drama.
      await manager.create(
        CircleAnnotationOptions(
          geometry: geometry,
          circleRadius: 24,
          circleColor: markerColor,
          circleOpacity: 0.38,
          circleBlur: 1.0,
        ),
      );
      // Bright core dot (15% bigger than before) with a thin white rim.
      await manager.create(
        CircleAnnotationOptions(
          geometry: geometry,
          circleRadius: 8.05,
          circleColor: markerColor,
          circleStrokeColor: Colors.white.toARGB32(),
          circleStrokeWidth: 2,
          circleStrokeOpacity: 0.85,
        ),
      );
    }

    // Non-deprecated tap API. One court for now, so any dot tap opens it;
    // once there are multiple courts, match the tapped annotation to a court
    // (e.g. via customData or an id→court map) instead of using .first.
    manager.tapEvents(onTap: (_) => _openVenueSheet(_courts.first));
  }

  void _openVenueSheet(_Court court) {
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => _VenueSheet(court: court),
    );
  }

  /// Remembers the current camera so a theme swap can restore it.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapboxMap?.getCameraState().then((c) {
      if (mounted) _lastCamera = c;
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            // Changing the key forces a fresh map when the style swaps;
            // without it the widget keeps the old style loaded.
            key: ValueKey(isDark),
            onMapCreated: _onMapCreated,
            styleUri: isDark ? MapStyles.dark : MapStyles.light,
            cameraOptions: CameraOptions(
              center: _lastCamera?.center ??
                  Point(coordinates: Position(-96.7502, 32.9857)),
              zoom: _lastCamera?.zoom ?? 14.3,
            ),
          ),
          // Gear sits top-right: the court markers live in the middle of the
          // screen and Mapbox's logo/attribution are pinned bottom-right, so
          // this is the one corner that collides with nothing.
          const Positioned(top: 8, right: 8, child: _SettingsButton()),
        ],
      ),
    );
  }
}

/// Opens the settings screen. Always available, not debug-gated.
class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Tooltip(
        message: 'Settings',
        child: Material(
          color: context.colors.surface.withValues(alpha: 0.9),
          shape: CircleBorder(side: BorderSide(color: context.colors.border)),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Icon(
                Icons.settings,
                size: 20.sp,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet shown when a court dot is tapped. Live count and check-in
/// are deliberate placeholders — the real data needs the Firestore sessions
/// collection and security rules, which is a separate, not-yet-built step.
class _VenueSheet extends StatelessWidget {
  final _Court court;

  const _VenueSheet({required this.court});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grab handle.
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.textSecondary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              court.name.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
                color: context.colors.textPrimary,
                height: 1.0,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                // Neon red live-status dot.
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonRed,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonRed.withValues(alpha: 0.6),
                        blurRadius: 8.r,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.people_outline,
                  size: 16.sp,
                  color: context.colors.textSecondary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Live players — coming soon',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Styled like the app's gradient button but NOT wired yet —
            // check-in needs the Firestore sessions collection + rules.
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [context.colors.steel, context.colors.steelLight],
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.steelLight.withValues(alpha: 0.5),
                    blurRadius: 24.r,
                    spreadRadius: 3.2.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                "I'M GOING!",
                style: GoogleFonts.poppins(
                  fontSize: 19.2.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.neonMint,
                  letterSpacing: 0.8,
                  shadows: [
                    Shadow(
                      color: AppColors.neonMint.withValues(alpha: 0.6),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                'Check-in coming soon',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
