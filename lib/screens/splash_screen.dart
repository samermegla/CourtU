import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/logo_wordmark.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pingController;

  late Animation<double> _logoScale;
  late Animation<double> _taglineFade;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _barFade;
  late Animation<double> _barWidth;
  late Animation<double> _ambientFade;

  // Court pins scattered inside the ping radius, around the logo.
  // dx/dy are offsets from the center of the screen.
  static const _pins = [
    _PinData(
      emoji: '🏐',
      label: 'Rec Main',
      color: AppColors.statusHot,
      dx: -82,
      dy: -118,
    ),
    _PinData(
      emoji: '🏀',
      label: 'North AC',
      color: AppColors.statusActive,
      dx: 84,
      dy: -132,
    ),
    _PinData(
      emoji: '🎾',
      label: 'Tennis Pav',
      color: AppColors.statusQuiet,
      dx: -86,
      dy: -30,
    ),
    _PinData(
      emoji: '🏸',
      label: 'East Arena',
      color: AppColors.statusEmpty,
      dx: 84,
      dy: -48,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _logoScale = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.21, curve: Curves.easeOut),
      ),
    );

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.4, curve: Curves.easeOut),
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.4, curve: Curves.easeOut),
      ),
    );

    _barFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.38, 0.5, curve: Curves.easeOut),
      ),
    );

    _barWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // Map backdrop + court pins ease in just behind the logo.
    _ambientFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.45, curve: Curves.easeOut),
      ),
    );

    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _entranceController.forward();

    Future.delayed(const Duration(milliseconds: 2700), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Flat background — the only glow on this screen is the logo's.
        color: context.colors.background,
        child: Stack(
          children: [
            // Campus map backdrop — grid + roads, well behind everything
            Positioned.fill(
              child: FadeTransition(
                opacity: _ambientFade,
                child: CustomPaint(
                  painter: _MapBackdropPainter(
                    steel: context.colors.steel,
                    border: context.colors.border,
                  ),
                ),
              ),
            ),
            // Ping rings
            ...List.generate(3, (i) => _PingRing(
              animation: _pingController,
              delay: i * 0.55,
            )),
            // Court pins sitting inside the ping radius
            ..._pins.map((pin) => Center(
              child: Transform.translate(
                offset: Offset(pin.dx.r, pin.dy.r),
                child: FadeTransition(
                  opacity: _ambientFade,
                  child: _CourtPin(pin: pin),
                ),
              ),
            )),
            // Main content
            Center(
              // Shift the whole block down so the LOGO PANE lands on the
              // vertical center (where the ping rings converge), instead of
              // the group as a whole being centered — which left the logo
              // sitting high. ~60 ≈ half the height of the text + bar below
              // the logo.
              child: Transform.translate(
                offset: Offset(0, 65.h),
                child: AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      // Logo mark
                      Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          width: 104.r,
                          height: 104.r,
                          decoration: BoxDecoration(
                            color: context.colors.surfaceAlt,
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: context.colors.steel.withValues(alpha: 0.33),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.steel.withValues(alpha: 0.45),
                                blurRadius: 52,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 40,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const LogoMark(size: 74),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      // Title (nudged up 10 to sit tighter under the logo)
                      Transform.translate(
                        offset: Offset(0, -10.h),
                        child: Text(
                          'CourtU',
                          style: GoogleFonts.poppins(
                            fontSize: 60.835.sp,
                            fontWeight: FontWeight.w900,
                            color: context.colors.textPrimary,
                            letterSpacing: 2.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Tagline
                      SlideTransition(
                        position: _taglineSlide,
                        child: FadeTransition(
                          opacity: _taglineFade,
                          child: Text(
                            'Play together. Level up.',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28.h),
                      // Loading bar
                      FadeTransition(
                        opacity: _barFade,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2.r),
                          child: Container(
                            width: 80.w,
                            height: 3.h,
                            color: context.colors.border,
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _barWidth.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [context.colors.steel, context.colors.steelLight],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// COURT PIN
// ─────────────────────────────────────────────
// A sport emoji in a colored circle with a short
// name underneath — the same pin the campus map
// uses, scattered here as splash set dressing.

class _PinData {
  final String emoji;
  final String label;
  final Color color;
  final double dx;
  final double dy;

  const _PinData({
    required this.emoji,
    required this.label,
    required this.color,
    required this.dx,
    required this.dy,
  });
}

class _CourtPin extends StatelessWidget {
  final _PinData pin;

  const _CourtPin({required this.pin});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pin.color.withValues(alpha: 0.10),
            border: Border.all(
              color: pin.color.withValues(alpha: 0.45),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(pin.emoji, style: TextStyle(fontSize: 16.sp)),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: context.colors.surface.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: pin.color.withValues(alpha: 0.2)),
          ),
          child: Text(
            pin.label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: pin.color.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MAP BACKDROP
// ─────────────────────────────────────────────
// Faint campus grid, roads and building outlines
// behind the rings.

class _MapBackdropPainter extends CustomPainter {
  /// Painters sit outside the widget tree, so they can't read `context`.
  /// The current theme's colors are handed in at construction instead.
  final Color steel;
  final Color border;

  const _MapBackdropPainter({required this.steel, required this.border});

  /// Campus buildings: (dx, dy, width, height), where dx/dy offset the
  /// building's center from the center of the screen — the same coordinate
  /// space the pins use, so a pin sits squarely on its building.
  ///
  /// The first four are the ones the pins stand on; their dy is 10 above the
  /// pin's own dy because a pin's circle sits 10 above its column center
  /// (the short-name label hangs below it).
  static const _buildings = [
    (-82.0, -128.0, 72.0, 46.0), // Rec Main
    (84.0, -142.0, 76.0, 48.0), // North AC
    (-86.0, -40.0, 74.0, 46.0), // Tennis Pav
    (84.0, -58.0, 72.0, 46.0), // East Arena
    // Unoccupied buildings, for campus texture
    (0.0, -196.0, 62.0, 34.0),
    (-138.0, 62.0, 54.0, 34.0),
    (132.0, 74.0, 58.0, 36.0),
    (-10.0, 150.0, 84.0, 40.0),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = steel.withValues(alpha: 0.09)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const step = 40.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final road = Paint()..color = border.withValues(alpha: 0.2);

    road.strokeWidth = 5;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      road,
    );
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      road,
    );

    // Big diagonal X, drawn at a true 45°: each line's horizontal travel
    // equals its vertical travel (slope ±1), crossing at the screen center.
    // On a tall screen this pushes the ends past the left/right edges, so the
    // X is clipped by the screen rather than tapering toward the corners.
    road.strokeWidth = 4;
    final cx = size.width / 2;
    final half = size.height / 2;
    canvas.drawLine(
      Offset(cx - half, 0),
      Offset(cx + half, size.height),
      road,
    );
    canvas.drawLine(
      Offset(cx + half, 0),
      Offset(cx - half, size.height),
      road,
    );

    // Building outlines, over the roads
    final buildingFill = Paint()
      ..color = border.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    final buildingStroke = Paint()
      ..color = steel.withValues(alpha: 0.16)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    for (final (dx, dy, w, h) in _buildings) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + Offset(dx.r, dy.r),
          width: w.r,
          height: h.r,
        ),
        Radius.circular(3.r),
      );
      canvas.drawRRect(rect, buildingFill);
      canvas.drawRRect(rect, buildingStroke);
    }
  }

  @override
  bool shouldRepaint(_MapBackdropPainter oldDelegate) => false;
}

class _PingRing extends StatelessWidget {
  final Animation<double> animation;
  final double delay;

  const _PingRing({
    required this.animation,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final elapsed = (animation.value + delay / 2.5) % 1.0;
        final scale = 0.85 + elapsed * 1.55;
        final opacity = (1.0 - elapsed) * 0.55;
        return Center(
          child: Opacity(
            opacity: opacity.clamp(0.0, 0.55),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 170.r,
                height: 170.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colors.steel.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
