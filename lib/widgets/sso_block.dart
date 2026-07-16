import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class SSOBlock extends StatelessWidget {
  /// Null disables the button — used while a sign-in is already in flight.
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onUniversitySSO;

  const SSOBlock({
    super.key,
    required this.onGoogleSignIn,
    required this.onUniversitySSO,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _googleButton(),
        SizedBox(height: 10.h),
        _universityButton(),
        SizedBox(height: 16.h),
        _divider(),
      ],
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onGoogleSignIn,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF111111),
          side: BorderSide.none,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _googleLogo(),
            SizedBox(width: 10.w),
            Text(
              'Continue with Google',
              style: GoogleFonts.dmSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _universityButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onUniversitySSO,
        icon: Icon(Icons.school, size: 15.sp, color: AppColors.mutedForeground),
        label: Text(
          'University SSO',
          style: GoogleFonts.dmSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.mutedForeground,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.muted,
          side: BorderSide(color: AppColors.steel.withValues(alpha: 0.2)),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: AppColors.steel.withValues(alpha: 0.16)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'or email',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.sp,
              letterSpacing: 2,
              color: const Color(0xFF4a5a72),
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: AppColors.steel.withValues(alpha: 0.16)),
        ),
      ],
    );
  }

  Widget _googleLogo() {
    return SizedBox(
      width: 17.r,
      height: 17.r,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final s = size.width / 18;

    paint.color = const Color(0xFF4285F4);
    canvas.drawPath(
      Path()
        ..moveTo(17.64 * s, 9.2 * s)
        ..cubicTo(17.64 * s, 8.563 * s, 17.583 * s, 7.949 * s, 17.476 * s, 7.36 * s)
        ..lineTo(9 * s, 7.36 * s)
        ..lineTo(9 * s, 10.841 * s)
        ..lineTo(13.844 * s, 10.841 * s)
        ..cubicTo(13.635 * s, 11.966 * s, 13.001 * s, 12.919 * s, 12.048 * s, 13.558 * s)
        ..lineTo(12.048 * s, 15.816 * s)
        ..lineTo(14.956 * s, 15.816 * s)
        ..cubicTo(16.658 * s, 14.249 * s, 17.64 * s, 11.942 * s, 17.64 * s, 9.2 * s)
        ..close(),
      paint,
    );

    paint.color = const Color(0xFF34A853);
    canvas.drawPath(
      Path()
        ..moveTo(9 * s, 18 * s)
        ..cubicTo(11.43 * s, 18 * s, 13.467 * s, 17.194 * s, 14.956 * s, 15.816 * s)
        ..lineTo(12.048 * s, 13.558 * s)
        ..cubicTo(11.242 * s, 14.098 * s, 10.211 * s, 14.418 * s, 9 * s, 14.418 * s)
        ..cubicTo(6.656 * s, 14.418 * s, 4.672 * s, 12.834 * s, 3.964 * s, 10.707 * s)
        ..lineTo(0.957 * s, 10.707 * s)
        ..lineTo(0.957 * s, 13.039 * s)
        ..cubicTo(2.438 * s, 15.983 * s, 5.482 * s, 18 * s, 9 * s, 18 * s)
        ..close(),
      paint,
    );

    paint.color = const Color(0xFFFBBC05);
    canvas.drawPath(
      Path()
        ..moveTo(3.964 * s, 10.707 * s)
        ..cubicTo(3.784 * s, 10.172 * s, 3.682 * s, 9.593 * s, 3.682 * s, 9 * s)
        ..cubicTo(3.682 * s, 8.407 * s, 3.784 * s, 7.83 * s, 3.964 * s, 7.293 * s)
        ..lineTo(3.964 * s, 4.961 * s)
        ..lineTo(0.957 * s, 4.961 * s)
        ..cubicTo(0.348 * s, 6.173 * s, 0 * s, 7.548 * s, 0 * s, 9 * s)
        ..cubicTo(0 * s, 10.452 * s, 0.348 * s, 11.827 * s, 0.957 * s, 13.039 * s)
        ..lineTo(3.964 * s, 10.707 * s)
        ..close(),
      paint,
    );

    paint.color = const Color(0xFFEA4335);
    canvas.drawPath(
      Path()
        ..moveTo(9 * s, 3.58 * s)
        ..cubicTo(10.321 * s, 3.58 * s, 11.508 * s, 4.034 * s, 12.44 * s, 4.925 * s)
        ..lineTo(15.022 * s, 2.345 * s)
        ..cubicTo(13.463 * s, 0.891 * s, 11.426 * s, 0 * s, 9 * s, 0 * s)
        ..cubicTo(5.482 * s, 0 * s, 2.438 * s, 2.017 * s, 0.957 * s, 4.961 * s)
        ..lineTo(3.964 * s, 7.293 * s)
        ..cubicTo(4.672 * s, 5.166 * s, 6.656 * s, 3.58 * s, 9 * s, 3.58 * s)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
