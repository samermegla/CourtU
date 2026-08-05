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
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.colors.steel.withValues(alpha: 0.2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: IconTheme(
                data: IconThemeData(
                  color: context.colors.textSecondary,
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
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: context.colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: context.colors.textSecondary,
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
