import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class AuthField extends StatelessWidget {
  final Widget? icon;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const AuthField({
    super.key,
    this.icon,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.steel.withValues(alpha: 0.2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: IconTheme(
                data: IconThemeData(
                  color: AppColors.mutedForeground,
                  size: 14.sp,
                ),
                child: icon!,
              ),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: GoogleFonts.dmSans(
                fontSize: 14.sp,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  color: const Color(0xFF4a5a72),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          ?suffix,
        ],
      ),
    );
  }
}
