import 'package:flutter/material.dart';
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.steel.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconTheme(
                data: const IconThemeData(
                  color: AppColors.mutedForeground,
                  size: 14,
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
                fontSize: 14,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: const Color(0xFF4a5a72),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          ?suffix,
        ],
      ),
    );
  }
}
