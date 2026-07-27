import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFFFFFFFF);
  static const card = Color(0xFF0f1626);
  static const muted = Color(0xFF131e33);
  static const dim = Color(0xFF1a2540);
  static const steel = Color(0xFF4B6D8A);
  static const steelLight = Color(0xFF6B9AB8);
  static const mutedForeground = Color(0xFF6b7fa3);
  static const foreground = Color(0xFFe8f0fe);
  static const accent = Color(0xFFff6b35);
  // Calm steel-blue — solid fill for primary CTA buttons (Let's Go, Get
  // Started, Create Account).
  static const accentBlue = Color(0xFF7B93B5);
  // Bright neon creamy red-orange — used for court markers on the map.
  static const courtMarker = Color(0xFFff6e4e);
  // Pastel neon light green — "I'm going" check-in call-to-action.
  static const neonMint = Color(0xFFa6ffb2);
  // Neon red — live-status indicator dot.
  static const neonRed = Color(0xFFff3b3b);
  static const green = Color(0xFF1ddf64);
  static const destructive = Color(0xFFef4444);

  // Court status colors
  static const statusHot = Color(0xFFff6b35);
  static const statusActive = Color(0xFF1ddf64);
  static const statusQuiet = Color(0xFFf59e0b);
  static const statusEmpty = Color(0xFF6b7fa3);

  // Sport colors
  static const volleyball = Color(0xFFff6b35);
  static const basketball = Color(0xFFf59e0b);
  static const tennis = Color(0xFF22d35a);
  static const badminton = Color(0xFF3b82f6);
  static const pickleball = Color(0xFFa855f7);

  static Color sportColor(String name) {
    switch (name) {
      case 'volleyball':
        return volleyball;
      case 'basketball':
        return basketball;
      case 'tennis':
        return tennis;
      case 'badminton':
        return badminton;
      case 'pickleball':
        return pickleball;
      default:
        return mutedForeground;
    }
  }
}
