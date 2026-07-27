import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';

// TODO: replace this placeholder tone list with real illustrated skin-tone
// swatches once avatar art assets exist.
const _skinTones = [
  Color(0xFFffdbac),
  Color(0xFFf1c27d),
  Color(0xFFe0ac69),
  Color(0xFFc68642),
  Color(0xFF8d5524),
  Color(0xFF5c3a21),
];

// TODO: these generic icons stand in for real illustrated hairstyle art.
// Swap each entry for a proper hairstyle asset later.
const _hairstyleIcons = [
  Icons.horizontal_rule, // "shaved"
  Icons.crop_square, // "buzz cut"
  Icons.change_history, // "spiky"
  Icons.circle, // "curly / afro"
  Icons.crop_7_5, // "long"
];

// TODO: replace with real jersey-color art / fabric swatches later. Reuses
// the app's existing sport colors so it doesn't invent a new palette.
const _jerseyColors = [
  AppColors.volleyball,
  AppColors.basketball,
  AppColors.tennis,
  AppColors.badminton,
  AppColors.pickleball,
  AppColors.steelLight,
];

/// Step 2: mix-and-match avatar builder. No illustrated art exists yet, so
/// every option here is a plain shape/color placeholder — see the TODOs
/// above and inline below for where real assets should be swapped in.
class AvatarStep extends StatelessWidget {
  final int skinToneIndex;
  final int hairstyleIndex;
  final int jerseyColorIndex;
  final ValueChanged<int> onSkinToneChanged;
  final ValueChanged<int> onHairstyleChanged;
  final ValueChanged<int> onJerseyColorChanged;

  const AvatarStep({
    super.key,
    required this.skinToneIndex,
    required this.hairstyleIndex,
    required this.jerseyColorIndex,
    required this.onSkinToneChanged,
    required this.onHairstyleChanged,
    required this.onJerseyColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Make it yours',
          textAlign: TextAlign.center,
          style: GoogleFonts.arimo(
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.0,
            letterSpacing: 0.64,
          ),
        ),
        SizedBox(height: 20.h),
        _AvatarPreview(
          skinTone: _skinTones[skinToneIndex],
          hairstyleIcon: _hairstyleIcons[hairstyleIndex],
          jerseyColor: _jerseyColors[jerseyColorIndex],
        ),
        SizedBox(height: 24.h),
        _CategoryLabel('SKIN TONE'),
        SizedBox(height: 10.h),
        _ColorSwatchRow(
          colors: _skinTones,
          selectedIndex: skinToneIndex,
          onTap: onSkinToneChanged,
        ),
        SizedBox(height: 18.h),
        _CategoryLabel('HAIRSTYLE'),
        SizedBox(height: 10.h),
        _IconSwatchRow(
          icons: _hairstyleIcons,
          selectedIndex: hairstyleIndex,
          onTap: onHairstyleChanged,
        ),
        SizedBox(height: 18.h),
        _CategoryLabel('JERSEY COLOR'),
        SizedBox(height: 10.h),
        _ColorSwatchRow(
          colors: _jerseyColors,
          selectedIndex: jerseyColorIndex,
          onTap: onJerseyColorChanged,
        ),
      ],
    );
  }
}

/// TODO: swap this whole preview for a real layered/illustrated avatar
/// render once art assets exist. For now it's a colored circle (skin tone)
/// with a shape overlay (hairstyle) and a color badge (jersey).
class _AvatarPreview extends StatelessWidget {
  final Color skinTone;
  final IconData hairstyleIcon;
  final Color jerseyColor;

  const _AvatarPreview({
    required this.skinTone,
    required this.hairstyleIcon,
    required this.jerseyColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.r,
      height: 140.r,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 110.r,
            height: 110.r,
            decoration: BoxDecoration(shape: BoxShape.circle, color: skinTone),
          ),
          Positioned(
            top: 0,
            child: Icon(hairstyleIcon, size: 34.sp, color: AppColors.card),
          ),
          Positioned(
            bottom: 4.r,
            child: Container(
              width: 40.r,
              height: 18.r,
              decoration: BoxDecoration(
                color: jerseyColor,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: AppColors.background, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  final String text;
  const _CategoryLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10.sp,
          letterSpacing: 1.2,
          color: const Color(0xFF4a5a72),
        ),
      ),
    );
  }
}

class _ColorSwatchRow extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _ColorSwatchRow({
    required this.colors,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(colors.length, (i) {
        final selected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onTap(i),
          child: Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[i],
              border: Border.all(
                color: selected ? AppColors.steelLight : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _IconSwatchRow extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _IconSwatchRow({
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(icons.length, (i) {
        final selected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onTap(i),
          child: Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.steel.withValues(alpha: 0.2)
                  : AppColors.muted,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: selected
                    ? AppColors.steelLight
                    : AppColors.steel.withValues(alpha: 0.16),
                width: 1.5,
              ),
            ),
            child: Icon(
              icons[i],
              size: 16.sp,
              color: selected ? AppColors.steelLight : AppColors.mutedForeground,
            ),
          ),
        );
      }),
    );
  }
}
