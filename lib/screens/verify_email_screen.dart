import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';

/// Holds a signed-in-but-unverified account until the user clicks the link
/// in their inbox. The AuthGate routes here whenever `emailVerified` is
/// false, so there is no way into the app around this screen.
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _authService = AuthService();

  Timer? _pollTimer;
  Timer? _cooldownTimer;
  int _cooldown = 0;

  @override
  void initState() {
    super.initState();
    // The server learns about verification instantly, but the app's cached
    // User doesn't — poll reload() while this screen is visible. When the
    // flag flips, reload makes `userChanges` emit and the AuthGate swaps
    // this screen for home; no navigation code needed here.
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _authService.reloadAndCheckVerified();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    try {
      await _authService.sendVerificationEmail();
      if (!mounted) return;
      setState(() => _cooldown = 60);
      _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        setState(() => _cooldown--);
        if (_cooldown <= 0) t.cancel();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent.')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = _authService.currentUser?.email ?? 'your email';
    final canResend = _cooldown <= 0;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.mark_email_unread_outlined,
                size: 56.sp,
                color: context.colors.steelLight,
              ),
              SizedBox(height: 20.h),
              Text(
                'Verify your email',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w900,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'We sent a verification link to\n$email',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  height: 1.5,
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Click the link, then come back here.\nCheck your spam folder if it\'s missing.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  height: 1.5,
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: 28.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 12.r,
                    height: 12.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(context.colors.steelLight),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Waiting for verification…',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11.sp,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              OutlinedButton(
                onPressed: canResend ? _resend : null,
                style: OutlinedButton.styleFrom(
                  backgroundColor: context.colors.surfaceAlt,
                  side: BorderSide(
                    color: context.colors.steel.withValues(alpha: 0.3),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  canResend ? 'RESEND EMAIL' : 'RESEND IN ${_cooldown}s',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: canResend
                        ? context.colors.textPrimary
                        : context.colors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              TextButton(
                onPressed: _authService.signOut,
                child: Text(
                  'Wrong email? Sign out',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: context.colors.steelLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
