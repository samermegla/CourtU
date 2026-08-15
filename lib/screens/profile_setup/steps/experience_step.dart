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
/// the combined details step (see [DetailsStep]). Required before the step
/// can be completed, but a slider always shows *some* position, so it rests
/// at 'New' -- the first of the six stops -- until the player touches it.
///
/// [onTouched] fires on interaction start rather than on value change,
/// because those differ in exactly the case that matters: a player who
/// really is 'New' taps the thumb where it already sits, which changes no
/// value and so never fires [onChanged]. Gating on [onChanged] alone would
/// leave that player unable to finish the step.
class ExperienceSlider extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onTouched;

  const ExperienceSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onTouched,
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
            onChangeStart: (_) => onTouched(),
            onChanged: (v) => onChanged(kExperienceLevels[v.round()]),
          ),
        ),
      ],
    );
  }
}
