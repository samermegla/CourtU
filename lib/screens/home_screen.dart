import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../services/auth_service.dart';

/// The signed-in landing screen — a placeholder for now.
///
/// It receives the [User] object straight from the auth gate's stream. Notice
/// we don't fetch the user here: the gate already has it, so we just pass it
/// down. That `user` is proof of identity — it came from the verified token,
/// not from anything we typed on this screen.
class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You're in.",
                style: GoogleFonts.barlowCondensed(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                // `user.email` is data Firebase handed back with the verified
                // session — a small demonstration that the token identifies you.
                'Signed in as ${user.email}',
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  color: AppColors.mutedForeground,
                ),
              ),
              SizedBox(height: 32.h),
              TextButton(
                // No manual navigation here. We just sign out. That flips the
                // auth stream to `null`, the gate rebuilds, and the app falls
                // back to the logged-out flow automatically. Watch for it.
                onPressed: () => AuthService().signOut(),
                child: Text(
                  'SIGN OUT',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: AppColors.steelLight,
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
