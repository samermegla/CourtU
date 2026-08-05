import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

/// Brief "Welcome, [nickname]!" moment shown right after Profile Setup
/// completes, before automatically advancing into [MapScreen].
class WelcomeScreen extends StatefulWidget {
  final String nickname;
  final VoidCallback onDone;

  const WelcomeScreen({
    super.key,
    required this.nickname,
    required this.onDone,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1500), widget.onDone);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Text(
          'Welcome, ${widget.nickname}!',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
            color: context.colors.textPrimary,
            height: 1.0,
            letterSpacing: 0.64,
          ),
        ),
      ),
    );
  }
}
