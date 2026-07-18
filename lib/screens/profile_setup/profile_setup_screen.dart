import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/step_dot_indicator.dart';
import 'profile_setup_data.dart';
import 'steps/avatar_step.dart';
import 'steps/competitiveness_step.dart';
import 'steps/experience_step.dart';
import 'steps/nickname_step.dart';
import 'steps/position_step.dart';

const _stepCount = 5;

/// A short, one-question-per-screen flow (nickname, avatar, positions,
/// experience, competitiveness) shown once right after a new account is
/// created and verified, before the user ever reaches [HomeScreen].
///
/// Reuses the onboarding flow's visual language: [GradientButton],
/// [StepDotIndicator], and the same AppColors/GoogleFonts split.
class ProfileSetupScreen extends StatefulWidget {
  final ValueChanged<ProfileSetupData> onComplete;

  const ProfileSetupScreen({super.key, required this.onComplete});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _step = 0;
  final _data = ProfileSetupData();

  bool get _canAdvance {
    switch (_step) {
      case 0:
        return _data.nickname.trim().isNotEmpty;
      case 1:
        return true; // avatar always has a valid default selection
      case 2:
        return _data.positions.isNotEmpty;
      case 3:
        return _data.experience != null;
      case 4:
        return _data.competitiveness != null;
      default:
        return false;
    }
  }

  void _next() {
    if (!_canAdvance) return;
    if (_step == _stepCount - 1) {
      widget.onComplete(_data);
      return;
    }
    setState(() => _step++);
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step--);
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return NicknameStep(
          key: const ValueKey('nickname'),
          initialValue: _data.nickname,
          onChanged: (v) => setState(() => _data.nickname = v),
        );
      case 1:
        return AvatarStep(
          key: const ValueKey('avatar'),
          skinToneIndex: _data.skinToneIndex,
          hairstyleIndex: _data.hairstyleIndex,
          jerseyColorIndex: _data.jerseyColorIndex,
          onSkinToneChanged: (i) => setState(() => _data.skinToneIndex = i),
          onHairstyleChanged: (i) => setState(() => _data.hairstyleIndex = i),
          onJerseyColorChanged: (i) =>
              setState(() => _data.jerseyColorIndex = i),
        );
      case 2:
        return PositionStep(
          key: const ValueKey('position'),
          selected: _data.positions,
          onToggle: (position) => setState(() {
            if (!_data.positions.remove(position)) {
              _data.positions.add(position);
            }
          }),
        );
      case 3:
        return ExperienceStep(
          key: const ValueKey('experience'),
          selected: _data.experience,
          onSelect: (v) => setState(() => _data.experience = v),
        );
      case 4:
        return CompetitivenessStep(
          key: const ValueKey('competitiveness'),
          selected: _data.competitiveness,
          onSelect: (v) => setState(() => _data.competitiveness = v),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = _step == _stepCount - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: _step > 0,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: GestureDetector(
                      onTap: _back,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chevron_right,
                            size: 14.sp,
                            color: const Color(0xFF4a5a72),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Back',
                            style: GoogleFonts.dmSans(
                              fontSize: 14.sp,
                              color: const Color(0xFF4a5a72),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  StepDotIndicator(count: _stepCount, activeIndex: _step),
                ],
              ),
            ),
            // Same scroll-safe pattern as onboarding_screen.dart: centers
            // the step content when there's room, scrolls it when the
            // viewport is too short.
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_buildStep()],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
              child: GradientButton(
                label: isLastStep ? "LET'S GO" : 'NEXT →',
                onTap: _next,
                enabled: _canAdvance,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
