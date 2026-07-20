import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/logo_wordmark.dart';

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
      tag: 'REAL-TIME MAP',
      emoji: '🗺️',
      emojiFontSize: 104.55,
      headline: 'YOUR CAMPUS\nIN REAL TIME.',
      body:
          'See which courts are buzzing now. Every rec, gym, and outdoor court - live.',
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
      tag: 'CONNECT',
      emoji: '🏐',
      headline: 'SHOW UP\nTOGETHER.',
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
      tag: 'CUSTOMIZE',
      emoji: '🦕',
      headline: 'CUSTOMIZE\nAND MAKE\nFRIENDS.',
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
            // Wrapped in a scroll view that anchors the content to the top
            // when there is room and scrolls it when the viewport is too
            // short — so the screen never throws an overflow error on small
            // devices. Anchored to the top (not centered) so the tag pill
            // and emoji card sit at the same fixed position on every slide,
            // regardless of how many lines that slide's headline/body wrap
            // to below it.
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: Offset(0, 8.h),
                              child: _TagPill(label: slide.tag),
                            ),
                            SizedBox(height: 32.h),
                            _EmojiCard(
                              emoji: slide.emoji,
                              emojiFontSize: slide.emojiFontSize,
                              floats: slide.floats,
                              accentColor: slide.accentColor,
                            ),
                            SizedBox(height: 24.h),
                            _SlideText(
                              headline: slide.headline,
                              body: slide.body,
                            ),
                            SizedBox(height: 24.h),
                            _DotIndicator(
                              count: _slides.length,
                              activeIndex: _step,
                              onTap: (i) => setState(() => _step = i),
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
              step: _step,
              isLastStep: _isLastStep,
              onNext: () => setState(() => _step++),
              onGetStarted: widget.onGetStarted,
              onSignIn: widget.onSignIn,
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
              color: label == 'REAL-TIME MAP'
                  ? Colors.red
                  : label == 'CONNECT'
                      ? Colors.green
                      : label == 'CUSTOMIZE'
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
              color: const Color(0xFFF5F5F0),
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
  final Color? accentColor;

  const _EmojiCard({
    required this.emoji,
    this.emojiFontSize = 82,
    this.floats = const [],
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = accentColor ?? AppColors.steel;
    // Total glow reach — how far past the card's edges the glow visually
    // extends. Sets the PNG glow's size.
    final double glowReach = 84.r;
    final double glowOuterSize = 180.r + 2 * glowReach;
    return SizedBox(
      width: 220.r,
      height: 220.r,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Glow (behind card) — PNG asset, sized to roughly the same
          // visual reach the old boxShadow glow had. Wrapped in Positioned
          // (not a plain Stack child) because non-positioned Stack children
          // get clamped to the Stack's own box (220.r) regardless of the
          // width/height given to them — Positioned is exempt from that,
          // so this can actually overflow past the card's edges.
          Positioned(
            top: (220.r - glowOuterSize) / 2,
            left: (220.r - glowOuterSize) / 2,
            width: glowOuterSize,
            height: glowOuterSize,
            child: Image.asset(
              'assets/images/glow_blue.png',
              fit: BoxFit.contain,
            ),
          ),
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
                  base.withValues(alpha: accentColor != null ? 0.22 : 0.08),
                  base.withValues(alpha: accentColor != null ? 0.22 : 0.08),
                ],
              ),
              border: Border.all(
                color: base.withValues(alpha: accentColor != null ? 0.6 : 0.27),
                width: 1.5,
              ),
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
// The headline (BarlowCondensed, bold, large) and
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
          style: GoogleFonts.barlowCondensed(
            fontSize: 38.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
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
            style: GoogleFonts.dmSans(
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
// A row of dots. The active dot is wider (24px)
// and colored steel blue. Inactive dots are small
// (6px) and dim. Tappable to jump to that slide.

class _DotIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _DotIndicator({
    required this.count,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return GestureDetector(
          onTap: () => onTap(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 24.w : 6.w,
            height: 6.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.r),
              color: isActive ? AppColors.steel : AppColors.dim,
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// 7. BOTTOM BUTTONS
// ─────────────────────────────────────────────
// Shows "LET'S GO" on slide 0, "NEXT" on slide 1, or "GET STARTED"
// + "ALREADY HAVE AN ACCOUNT" on the last slide. All three carry a
// trailing arrow icon (added by _GradientButton itself).

class _BottomButtons extends StatelessWidget {
  final int step;
  final bool isLastStep;
  final VoidCallback onNext;
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const _BottomButtons({
    required this.step,
    required this.isLastStep,
    required this.onNext,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isLastStep)
            _GradientButton(
              label: step == 0 ? "LET'S GO" : 'NEXT',
              onTap: onNext,
            )
          else
            _GradientButton(label: 'GET STARTED', onTap: onGetStarted),
          SizedBox(height: 20.h),
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

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Glow — PNG asset, replacing the old boxShadow. Positioned with
          // negative insets (not width/height) so it stretches to bleed
          // past the button's actual rendered size (which is dynamic,
          // width: double.infinity) on all sides, roughly matching the old
          // shadow's blur(60.r) + spread(8.r) reach.
          Positioned(
            left: -36.r,
            right: -36.r,
            top: -30.r,
            bottom: -38.r,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/glow_blue_ellipse.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.steel, AppColors.steelLight],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward, size: 16.sp, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
  final Color? accentColor;

  const _SlideData({
    required this.tag,
    required this.emoji,
    this.emojiFontSize = 82,
    required this.headline,
    required this.body,
    this.floats = const [],
    this.accentColor,
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
