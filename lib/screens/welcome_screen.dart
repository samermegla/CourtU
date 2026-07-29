import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

/// A brief transitional screen shown right after the user picks a username.
/// The greeting fades in, holds, then fades out, at which point [onComplete]
/// fires so the caller can advance to whatever comes next.
class WelcomeScreen extends StatefulWidget {
  final String username;

  /// Called once the fade-out finishes. This is the hook for the screen that
  /// comes after — wire it up to whatever gets built later.
  final VoidCallback? onComplete;

  const WelcomeScreen({super.key, required this.username, this.onComplete});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    // One controller drives the whole beat: fade in, hold, fade out.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // 0.0–0.3 fade in, 0.3–0.7 hold at full, 0.7–1.0 fade out.
    _opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 40),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Welcome ${widget.username} :)',
              textAlign: TextAlign.center,
              style: GoogleFonts.barlowCondensed(
                fontSize: 40.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.0,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
