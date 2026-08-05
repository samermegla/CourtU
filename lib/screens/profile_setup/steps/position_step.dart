import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';

const kPositions = [
  'Outside Hitter',
  'Middle Blocker',
  'Right Side',
  'Libero',
  'Defensive Specialist',
  'Setter',
];

/// Step 3: "Which positions do you play?" — multi-select chips, same
/// selected/unselected treatment as the sport selector on the signup screen.
class PositionStep extends StatelessWidget {
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const PositionStep({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Which positions\ndo you play?',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
            color: context.colors.textPrimary,
            height: 1.0,
            letterSpacing: 0.64,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Pick as many as apply',
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: 24.h),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.w,
          runSpacing: 8.h,
          children: kPositions.map((position) {
            final isSelected = selected.contains(position);
            return GestureDetector(
              onTap: () => onToggle(position),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.steel.withValues(alpha: 0.2)
                      : context.colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? context.colors.steelLight
                        : context.colors.steel.withValues(alpha: 0.16),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  position,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? context.colors.steelLight : context.colors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
