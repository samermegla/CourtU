import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';

/// Bottom sheet shown when a court dot is tapped on the map.
///
/// Empty for now — content (court name, "I'm going" action, etc.) comes later.
/// [court] is the plain Firestore map for the tapped court (id + fields), so
/// the sheet has everything it needs once we start filling it in.
class ImGoingSheet extends StatelessWidget {
  final Map<String, dynamic> court;

  const ImGoingSheet({
    super.key,
    required this.court,
  });

  /// Slides the sheet up from the bottom of the screen.
  static Future<void> show(
    BuildContext context, {
    required Map<String, dynamic> court,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ImGoingSheet(court: court),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: Border.all(color: AppColors.steel.withValues(alpha: 0.2)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle.
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.steel.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          // TODO: court details + "I'm going" action.
        ],
      ),
    );
  }
}
