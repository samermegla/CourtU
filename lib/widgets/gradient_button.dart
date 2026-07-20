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
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Glow — PNG asset. Positioned with negative insets (not
            // width/height) so it stretches to bleed past the button's
            // actual rendered size (which is dynamic, width: double.infinity)
            // on all sides. Sits inside the Opacity above, so it fades with
            // the rest of the button when disabled.
            Positioned(
              left: -36.r,
              right: -36.r,
              top: -30.r,
              bottom: -38.r,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/glow_blue_ellipse.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.steel, AppColors.steelLight],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.barlowCondensed(
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
          ],
        ),
      ),
    );
  }
}
