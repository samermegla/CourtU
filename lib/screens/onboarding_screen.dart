import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/gradient_button.dart';
import '../widgets/logo_wordmark.dart';
import '../widgets/step_dot_indicator.dart';

// ─────────────────────────────────────────────
// 1. SCREEN SHELL
// ─────────────────────────────────────────────
// OnboardingScreen manages a _step counter (0, 1, or 2)
// and holds the 3 slides' data. It builds the whole
// screen as a Column: TopBar → (spacer) → Slide area
// (TagPill + EmojiCard + SlideText + Dots) → BottomButtons.

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const OnboardingScreen({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  static final _slides = [
    _SlideData(
      tag: 'real-time map',
      emoji: '🗺️',
      emojiFontSize: 104.55,
      headline: 'Your courts.\nReal time.',
      body: "See what's buzzing now.",
      floats: [
        _FloatData(
          top: 24,
          right: 11,
          child: _FloatBadge(text: '🔥 PACKED!!'),
        ),
        _FloatData(
          bottom: 25,
          left: 8,
          child: _FloatBadge(text: '22/24 PLAYERS'),
        ),
      ],
    ),
    _SlideData(
      tag: 'connect',
      emoji: '🏐',
      headline: 'Show up\ntogether.',
      body:
          'Tap into a court to let others know you\'re there. Rally up players in seconds, not hours.',
      floats: [
        _FloatData(
          bottom: 30,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.steel.withValues(alpha: 0.27),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '11 PLAYERS NEARBY',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: AppColors.steelLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    _SlideData(
      tag: 'customize',
      emoji: '🦕',
      headline: 'Customize\nand make\nfriends.',
      body:
          'Personalize your sports identity.\nInvite your friends to join!',
      floats: [
        _FloatData(
          top: 20,
          right: 12,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.steel.withValues(alpha: 0.27),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CHAT:',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9.sp,
                    letterSpacing: 1.2,
                    color: const Color(0xFF4a5a72),
                  ),
                ),
                Text(
                  "I'M GOING!",
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.steelLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ];

  bool get _isLastStep => _step == _slides.length - 1;

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_step];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar (always visible) ──
            _TopBar(onSkip: widget.onGetStarted),

            // ── Slide content (takes remaining space) ──
            // Wrapped in a scroll view that centers the content when there is
            // room and scrolls it when the viewport is too short — so the
            // screen never throws an overflow error on small devices.
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
                          mainAxisSize: MainAxisSize.min,
                          // Top-anchored (not centered) so the tag, emoji
                          // card, etc. sit at the exact same spot on every
                          // slide — only the trailing whitespace below the
                          // body text grows/shrinks with each slide's text
                          // length, instead of the whole group drifting.
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Fixed gap below the top bar — the anchor point
                            // every slide's tag pill is flush against.
                            SizedBox(height: 30.h),
                            _TagPill(label: slide.tag),
                            SizedBox(height: 32.h),
                            _EmojiCard(
                              emoji: slide.emoji,
                              emojiFontSize: slide.emojiFontSize,
                              floats: slide.floats,
                            ),
                            SizedBox(height: 24.h),
                            _SlideText(
                              headline: slide.headline,
                              body: slide.body,
                            ),
                            // Extra breathing room before the buttons. Lives
                            // in the scroll-safe area (scrolls instead of
                            // overflowing on short screens) rather than in
                            // _BottomButtons' fixed padding.
                            SizedBox(height: 42.h),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Bottom buttons (always visible) ──
            _BottomButtons(
              isLastStep: _isLastStep,
              stepCount: _slides.length,
              activeStep: _step,
              onNext: () => setState(() => _step++),
              onGetStarted: widget.onGetStarted,
              onSignIn: widget.onSignIn,
              onDotTap: (i) => setState(() => _step = i),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 2. TOP BAR
// ─────────────────────────────────────────────
// Shows the LogoWordmark on the left and a
// "SKIP →" button on the right. The skip button
// calls onSkip (jumps straight to signup).

class _TopBar extends StatelessWidget {
  final VoidCallback onSkip;

  const _TopBar({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      child: Row(
        // Logo pinned left, SKIP pinned right, both vertically centered.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const LogoWordmark(size: 24),
          GestureDetector(
            onTap: onSkip,
            child: Text(
              'SKIP →',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11.sp,
                color: const Color(0xFF4a5a72),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 3. TAG PILL
// ─────────────────────────────────────────────
// A small rounded badge with a glowing dot and
// the slide's label in uppercase monospace text.

class _TagPill extends StatelessWidget {
  final String label;
  const _TagPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.steel.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.steel.withValues(alpha: 0.27),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glowing dot
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: label == 'real-time map'
                  ? Colors.red
                  : label == 'connect'
                      ? Colors.green
                      : label == 'customize'
                          ? Colors.blue
                          : AppColors.steelLight,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 4. EMOJI CARD
// ─────────────────────────────────────────────
// A large rounded square with a subtle gradient
// background and border, showing a big emoji.

class _EmojiCard extends StatelessWidget {
  final String emoji;
  final double emojiFontSize;
  final List<_FloatData> floats;

  const _EmojiCard({
    required this.emoji,
    this.emojiFontSize = 82,
    this.floats = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220.r,
      height: 220.r,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Card
          Container(
            width: 180.r,
            height: 180.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.steel.withValues(alpha: 0.08),
                  AppColors.steel.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: AppColors.steel.withValues(alpha: 0.27),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.steel.withValues(alpha: 0.45),
                  blurRadius: 40.r,
                  spreadRadius: 6.4.r,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: TextStyle(fontSize: emojiFontSize.sp)),
          ),
          // Floating badges
          ...floats.map((f) => Positioned(
            top: f.top?.r,
            left: f.left?.r,
            right: f.right?.r,
            bottom: f.bottom?.r,
            child: f.child,
          )),
        ],
      ),
    );
  }
}

class _FloatData {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Widget child;

  const _FloatData({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.child,
  });
}

// ─────────────────────────────────────────────
// 5. SLIDE TEXT
// ─────────────────────────────────────────────
// The headline (Arimo — Helvetica Now stand-in, bold, large) and
// body paragraph (DMSans, muted color).

class _SlideText extends StatelessWidget {
  final String headline;
  final String body;
  const _SlideText({required this.headline, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          headline,
          textAlign: TextAlign.center,
          style: GoogleFonts.arimo(
            fontSize: 38.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 0.92,
            letterSpacing: 0.38,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: 260.w,
          child: Text(
            body,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.mutedForeground,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 6. DOT INDICATOR
// ─────────────────────────────────────────────
// Uses the shared StepDotIndicator widget (widgets/step_dot_indicator.dart).

// ─────────────────────────────────────────────
// 7. BOTTOM BUTTONS
// ─────────────────────────────────────────────
// Shows "NEXT →" on slides 0-1, or "GET STARTED"
// + "ALREADY HAVE AN ACCOUNT" on the last slide.

class _BottomButtons extends StatelessWidget {
  final bool isLastStep;
  final int stepCount;
  final int activeStep;
  final VoidCallback onNext;
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;
  final ValueChanged<int> onDotTap;

  const _BottomButtons({
    required this.isLastStep,
    required this.stepCount,
    required this.activeStep,
    required this.onNext,
    required this.onGetStarted,
    required this.onSignIn,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 3.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isLastStep)
            GradientButton(label: 'NEXT', onTap: onNext)
          else
            GradientButton(label: 'GET STARTED', onTap: onGetStarted),
          SizedBox(height: 20.h),
          StepDotIndicator(
            count: stepCount,
            activeIndex: activeStep,
            onTap: onDotTap,
          ),
          SizedBox(height: 10.h),
          Visibility(
            visible: isLastStep,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: TextButton(
              onPressed: onSignIn,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
              ),
              child: Text(
                'ALREADY HAVE AN ACCOUNT',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedForeground,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// GradientButton is now the shared widgets/gradient_button.dart widget.

// ─────────────────────────────────────────────
// DATA: Slide content definition
// ─────────────────────────────────────────────

class _SlideData {
  final String tag;
  final String emoji;
  final double emojiFontSize;
  final String headline;
  final String body;
  final List<_FloatData> floats;

  const _SlideData({
    required this.tag,
    required this.emoji,
    this.emojiFontSize = 82,
    required this.headline,
    required this.body,
    this.floats = const [],
  });
}

class _FloatBadge extends StatelessWidget {
  final String text;

  const _FloatBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.steel.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.steel.withValues(alpha: 0.33),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.steelLight,
        ),
      ),
    );
  }
}
