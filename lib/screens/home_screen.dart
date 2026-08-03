import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';
import '../widgets/logo_wordmark.dart';
import 'map_screen.dart';

/// Placeholder landing screen for signed-in, verified users.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final email = authService.currentUser?.email ?? 'unknown';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogoWordmark(size: 28),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Text(
                      'You\'re in!',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Signed in as $email',
                      style: GoogleFonts.dmSans(
                        fontSize: 14.sp,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      // Pushes the map screen onto the navigation stack; the
                      // system back gesture pops it and returns here.
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MapScreen(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                      ),
                      child: Text(
                        'View map',
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    OutlinedButton(
                      onPressed: authService.signOut,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.steel.withValues(alpha: 0.4),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                      ),
                      child: Text(
                        'Sign out',
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
