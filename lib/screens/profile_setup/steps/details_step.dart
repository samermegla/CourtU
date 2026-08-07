import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';
import 'experience_step.dart';
import 'position_step.dart';

const kCourtTypes = ['Indoor', 'Sand', 'Grass'];

/// Step 2 of Profile Setup: everything except the nickname, on one page --
/// positions, experience, and court type, each a compact labeled section
/// rather than its own full headline (see CLAUDE.md's Phase 2B notes for
/// why: four 32sp headlines stacked doesn't read as generous spacing, it
/// reads as four screens' worth of competing questions).
///
/// Avatar customization and competitiveness were cut from this flow --
/// the italic line at the bottom is the only trace of the former, pointing
/// at Settings instead of building a page that doesn't exist yet.
class DetailsStep extends StatelessWidget {
  final Set<String> positions;
  final ValueChanged<String> onTogglePosition;
  final String experience;
  final ValueChanged<String> onExperienceChanged;
  final Set<String> courtTypes;
  final ValueChanged<String> onToggleCourtType;

  const DetailsStep({
    super.key,
    required this.positions,
    required this.onTogglePosition,
    required this.experience,
    required this.onExperienceChanged,
    required this.courtTypes,
    required this.onToggleCourtType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tell us how\nyou play',
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
        ChipMultiSelect(
          label: 'POSITIONS',
          options: kPositions,
          selected: positions,
          onToggle: onTogglePosition,
        ),
        SizedBox(height: 22.h),
        ExperienceSlider(value: experience, onChanged: onExperienceChanged),
        SizedBox(height: 22.h),
        ChipMultiSelect(
          label: 'COURT TYPE',
          options: kCourtTypes,
          selected: courtTypes,
          onToggle: onToggleCourtType,
        ),
        SizedBox(height: 18.h),
        Text(
          'Customization coming soon in Settings',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            fontStyle: FontStyle.italic,
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
