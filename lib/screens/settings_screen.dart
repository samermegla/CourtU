import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart' show themeController;
import '../services/auth_service.dart';
import '../theme/colors.dart';

/// App settings. Reached from the gear button on the map.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        backgroundColor: context.colors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        children: [
          _SectionLabel('APPEARANCE'),
          SizedBox(height: 10.h),
          const _AppearanceCard(),
          SizedBox(height: 28.h),
          _SectionLabel('ACCOUNT'),
          SizedBox(height: 10.h),
          const _SignOutTile(),
          if (kDebugMode) ...[
            SizedBox(height: 28.h),
            _SectionLabel('DEVELOPER'),
            SizedBox(height: 10.h),
            const _DevResetTile(),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 11.sp,
        letterSpacing: 1.4,
        color: context.colors.textSecondary,
      ),
    );
  }
}

/// Light / Dark / System picker. Applies immediately and is remembered
/// across restarts by [ThemeController].
class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            children: [
              _ThemeOption(
                label: 'Light',
                icon: Icons.light_mode_outlined,
                mode: ThemeMode.light,
                selected: themeController.mode == ThemeMode.light,
              ),
              _Divider(),
              _ThemeOption(
                label: 'Dark',
                icon: Icons.dark_mode_outlined,
                mode: ThemeMode.dark,
                selected: themeController.mode == ThemeMode.dark,
              ),
              _Divider(),
              _ThemeOption(
                label: 'System',
                subtitle: 'Follow my phone setting',
                icon: Icons.phone_iphone,
                mode: ThemeMode.system,
                selected: themeController.mode == ThemeMode.system,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: context.colors.border);
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData icon;
  final ThemeMode mode;
  final bool selected;

  const _ThemeOption({
    required this.label,
    this.subtitle,
    required this.icon,
    required this.mode,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final accent = context.colors.accent;
    return InkWell(
      onTap: () => themeController.setMode(mode),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: selected ? accent : context.colors.textSecondary,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: context.colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle, size: 20.sp, color: accent),
          ],
        ),
      ),
    );
  }
}

/// Real sign out — clears the Firebase session. Visible to everyone.
class _SignOutTile extends StatelessWidget {
  const _SignOutTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () async {
          final navigator = Navigator.of(context);
          await AuthService().signOut();
          // AuthGate rebuilds to the signed-out flow on its own; popping just
          // clears this screen off the stack.
          navigator.popUntil((route) => route.isFirst);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(Icons.logout, size: 20.sp, color: AppColors.destructive),
              SizedBox(width: 14.w),
              Text(
                'Sign out',
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.destructive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Debug-only. Replays the loading/onboarding/setup flow.
///
/// NOTE: this currently works by signing out, because splash and onboarding
/// only appear to signed-out users. That means it also ends the session and
/// will require signing in again. A version that replays without signing out
/// needs an AuthGate change and is a separate task — hence the explicit
/// "(signs out)" in the label so the behavior is never a surprise.
class _DevResetTile extends StatelessWidget {
  const _DevResetTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.destructive.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () async {
          final navigator = Navigator.of(context);
          await AuthService().signOut();
          navigator.popUntil((route) => route.isFirst);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(Icons.replay, size: 20.sp, color: AppColors.destructive),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dev: Reset & Replay Onboarding',
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Text(
                      'Signs you out — you will need to sign in again',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
