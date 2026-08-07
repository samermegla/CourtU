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
  // Catch-all for players without a formal indoor position -- a fallback,
  // not a peer of the six above, so it sits last rather than alphabetized
  // or grouped in.
  'Outdoor',
];

/// A labeled row of multi-select toggle chips. Selecting one never
/// deselects another -- each chip just flips its own membership in
/// [selected]. Used for both positions and court type on the combined
/// details step (see [DetailsStep]).
class ChipMultiSelect extends StatelessWidget {
  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const ChipMultiSelect({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10.sp,
            letterSpacing: 1.2,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () => onToggle(option),
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
                  option,
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
