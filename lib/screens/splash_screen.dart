import 'package:flutter/material.dart';
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
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [
              Color(0x284B6D8A),
              Color(0xFF080d18),
            ],
            stops: [0.0, 0.65],
          ),
        ),
        child: Stack(
          children: [
            // Ping rings
            ...List.generate(3, (i) => _PingRing(
              animation: _pingController,
              delay: i * 0.55,
            )),
            // Main content
            Center(
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
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            color: AppColors.muted,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.steel.withValues(alpha: 0.33),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.steel.withValues(alpha: 0.45),
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
                      const SizedBox(height: 20),
                      // Title
                      Text(
                        'COURTU',
                        style: GoogleFonts.barlowCondensed(
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Tagline
                      SlideTransition(
                        position: _taglineSlide,
                        child: FadeTransition(
                          opacity: _taglineFade,
                          child: Text(
                            'Play together. Level up.',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Loading bar
                      FadeTransition(
                        opacity: _barFade,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Container(
                            width: 80,
                            height: 3,
                            color: AppColors.dim,
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _barWidth.value,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.steel, AppColors.steelLight],
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
          ],
        ),
      ),
    );
  }
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
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.steel.withValues(alpha: 0.6),
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
