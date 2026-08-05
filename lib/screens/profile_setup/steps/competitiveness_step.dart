import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';

const kCompetitivenessLevels = ['Just for Fun', 'Balanced', 'Highly Competitive'];

/// Step 5: single-select competitiveness level.
class CompetitivenessStep extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;

  const CompetitivenessStep({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'How competitive\nare you?',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
            color: context.colors.textPrimary,
            height: 1.0,
            letterSpacing: 0.64,
          ),
        ),
        SizedBox(height: 28.h),
        ...kCompetitivenessLevels.map((level) {
          final isSelected = selected == level;
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: GestureDetector(
              onTap: () => onSelect(level),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.steel.withValues(alpha: 0.2)
                      : context.colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? context.colors.steelLight
                        : context.colors.steel.withValues(alpha: 0.16),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        level,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? context.colors.steelLight
                              : context.colors.textPrimary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        size: 18.sp,
                        color: context.colors.steelLight,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
