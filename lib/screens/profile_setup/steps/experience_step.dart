import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';

const kExperienceLevels = [
  'New',
  'Beginner',
  'Intermediate',
  'Advanced',
  'Semi-pro',
  'Pro',
];

/// A labeled slider for experience level, one of the compact sections on
/// the combined details step (see [DetailsStep]). Optional field, but a
/// slider always shows *some* position, so it starts at 'Intermediate' --
/// the middle of the six stops -- until the player drags it.
class ExperienceSlider extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const ExperienceSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final index = kExperienceLevels.indexOf(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'EXPERIENCE',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10.sp,
                letterSpacing: 1.2,
                color: context.colors.textSecondary,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: context.colors.steelLight,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: context.colors.steel,
            inactiveTrackColor: context.colors.border,
            thumbColor: context.colors.steelLight,
            overlayColor: context.colors.steelLight.withValues(alpha: 0.2),
            valueIndicatorColor: context.colors.steel,
          ),
          child: Slider(
            value: index.toDouble(),
            min: 0,
            max: (kExperienceLevels.length - 1).toDouble(),
            divisions: kExperienceLevels.length - 1,
            label: value,
            onChanged: (v) => onChanged(kExperienceLevels[v.round()]),
          ),
        ),
      ],
    );
  }
}
