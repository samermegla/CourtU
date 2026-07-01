import 'package:flutter/material.dart';
import '../theme/colors.dart';

class LogoMark extends StatelessWidget {
  final double size;
  const LogoMark({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class LogoWordmark extends StatelessWidget {
  final double size;
  const LogoWordmark({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LogoMark(size: size),
        SizedBox(width: size * 0.0625),
        Text.rich(
          TextSpan(
            text: 'COURT',
            style: TextStyle(
              fontFamily: 'BarlowCondensed',
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: size * 0.55,
              letterSpacing: 0.05 * size * 0.55,
            ),
            children: [
              TextSpan(
                text: 'U',
                style: TextStyle(color: AppColors.steelLight),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
