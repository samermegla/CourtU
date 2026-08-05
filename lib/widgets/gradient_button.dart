import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

/// The steel-gradient, glowing "NEXT →" / "LET'S GO" style button shared by
/// the onboarding and profile setup flows.
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: context.colors.accent,
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: context.colors.accent.withValues(alpha: 0.5),
                      blurRadius: 24.r,
                      spreadRadius: 3.2.r,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.arrow_forward, size: 16.sp, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
