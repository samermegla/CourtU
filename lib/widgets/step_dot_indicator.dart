import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';

/// The pill-and-dot step progress indicator shared by the onboarding and
/// profile setup flows. Pass [onTap] to make dots jump to a step; omit it
/// for a purely visual, non-interactive progress display.
class StepDotIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;
  final ValueChanged<int>? onTap;

  const StepDotIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        final dot = AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 24.w : 6.w,
          height: 6.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.r),
            color: isActive ? context.colors.steel : context.colors.border,
          ),
        );
        if (onTap == null) return dot;
        return GestureDetector(onTap: () => onTap!(i), child: dot);
      }),
    );
  }
}
