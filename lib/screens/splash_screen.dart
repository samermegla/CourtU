// CourtU opening loader — Flutter port of "Opening Sequence.dc.html".
//
// Geometry is authored on a 1080 x 1920 reference canvas and scaled to the real
// screen, so it matches the HTML version exactly at any size. This screen does
// its own uniform scaling rather than using ScreenUtil's .w/.h, because a single
// scale factor is what keeps the bounce arcs in proportion on tall phones.
//
//   SplashScreen(onComplete: () => Navigator.pushReplacement(...))
//
// Poppins comes from google_fonts, as everywhere else in the app.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

// ── reference canvas ────────────────────────────────────────────────────────
const double _refW = 1080, _refH = 1920;
const double _cx = 540, _cy = 880; // lock point (also the bounce plane)
const double _ballR = 84;

// ── timeline (seconds) ──────────────────────────────────────────────────────
// Three phases: 1.3s of bounce, 0.6s holding on the lock, 0.6s fading out.
const double _total = 2.5;
const double _c1 = 0.68; // first contact
const double _c2 = 1.00; // second contact
const double _lock = 1.30; // ball comes to rest — end of the bounce
const double _fadeOut = 1.90; // screen starts fading — end of the hold

double _clamp01(double v) => v.clamp(0.0, 1.0);

double _easeOutQuad(double t) => 1 - (1 - t) * (1 - t);
double _easeInQuad(double t) => t * t;
double _easeOutCubic(double t) => 1 - math.pow(1 - t, 3).toDouble();

/// Eased tween over an absolute time window.
double _seg(double t, double start, double end, double from, double to,
    double Function(double) ease) {
  final p = _clamp01((t - start) / (end - start));
  return lerpDouble(from, to, ease(p))!;
}

/// Parabolic hop between two contacts, apex [h] above the plane.
double _arc(double t, double t0, double t1, double h) {
  final u = _clamp01((t - t0) / (t1 - t0));
  return _cy - h * 4 * u * (1 - u);
}

/// 1 at the contact instant, falling to 0 over +/- [w] seconds.
double _pulse(double t, double at, double w) =>
    _clamp01(1 - (t - at).abs() / w);

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.onComplete,
    this.showWordmark = true,
    this.tagline = 'Rally up.',
  });

  /// Fired once when the sequence completes — route to the app here.
  final VoidCallback? onComplete;
  final bool showWordmark;
  final String tagline;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500), // _total
  );

  @override
  void initState() {
    super.initState();
    // A cancelled ticker (disposed mid-sequence) still completes this future,
    // so the mounted check keeps a torn-down splash from routing anyway.
    _c.forward().whenComplete(() {
      if (mounted) widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: LayoutBuilder(
        builder: (context, box) {
          // Uniform scale, centred — same framing as the HTML stage.
          final s = math.min(box.maxWidth / _refW, box.maxHeight / _refH);
          return Center(
            child: SizedBox(
              width: _refW * s,
              height: _refH * s,
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, _) => _Frame(
                  t: _c.value * _total,
                  scale: s,
                  ink: colors.textPrimary,
                  accent: colors.accent,
                  showWordmark: widget.showWordmark,
                  tagline: widget.tagline,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.t,
    required this.scale,
    required this.ink,
    required this.accent,
    required this.showWordmark,
    required this.tagline,
  });

  final double t, scale;
  final Color ink, accent;
  final bool showWordmark;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    // Ball travels left-to-centre across the whole bounce, eased out.
    final x = _seg(t, 0, _lock, -220, _cx, _easeOutQuad);

    // Drop in, then two decaying hops that die out exactly at the lock point.
    final double y;
    if (t < _c1) {
      y = _seg(t, 0, _c1, -260, _cy, _easeInQuad);
    } else if (t < _c2) {
      y = _arc(t, _c1, _c2, 430);
    } else {
      y = _arc(t, _c2, _lock, 165);
    }

    // Squash on each contact, anchored to the bottom of the ball.
    final sq = [
      _pulse(t, _c1, 0.055),
      _pulse(t, _c2, 0.042),
      _pulse(t, _lock, 0.040),
    ].reduce(math.max);
    final sx = 1 + 0.20 * sq, sy = 1 - 0.20 * sq;

    // Ping ring: fires on lock, expands to 5.4x over 1.05s, eased fade.
    final rp = (t - _lock) / 1.05;
    final ringVisible = rp >= 0 && rp <= 1;
    final ringScale = ringVisible ? lerpDouble(1, 5.4, _easeOutCubic(rp))! : 1.0;
    final ringOpacity = ringVisible ? (1 - rp) * (1 - rp) * 0.34 : 0.0;

    // Wordmark is on screen for exactly 1.2s: in on the lock instant, out when
    // the screen finishes fading. Rising in and continuing to rise on the way
    // out makes the exit read as a slide-fade rather than a plain dim.
    final markOpacity = _seg(t, _lock, _lock + 0.28, 0, 1, _easeOutCubic);
    final markRise = _seg(t, _lock, _lock + 0.32, 20, 0, _easeOutCubic);
    final markExit = _seg(t, _fadeOut, _total, 0, -20, _easeInQuad);

    final out = 1 - _clamp01((t - _fadeOut) / (_total - _fadeOut));

    final d = _ballR * 2 * scale;

    return Opacity(
      opacity: _clamp01(out),
      child: ClipRect(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            if (ringOpacity > 0)
              Positioned(
                left: (_cx - _ballR) * scale,
                top: (_cy - _ballR) * scale,
                width: d,
                height: d,
                child: Transform.scale(
                  scale: ringScale,
                  child: Opacity(
                    opacity: _clamp01(ringOpacity),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accent, width: 5 * scale),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: (x - _ballR) * scale,
              top: (y - _ballR) * scale,
              width: d,
              height: d,
              child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.diagonal3Values(sx, sy, 1),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: ink, shape: BoxShape.circle),
                ),
              ),
            ),
            if (showWordmark)
              Positioned(
                left: 0,
                right: 0,
                top: (_cy + _ballR + 70) * scale,
                child: Opacity(
                  opacity: _clamp01(markOpacity),
                  child: Transform.translate(
                    offset: Offset(0, (markRise + markExit) * scale),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'CourtU',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w900,
                            fontSize: 182 * scale,
                            height: 0.9,
                            letterSpacing: -0.03 * 182 * scale,
                            color: ink,
                          ),
                        ),
                        SizedBox(height: 18 * scale),
                        Text(
                          tagline.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 42 * scale,
                            height: 1.2,
                            letterSpacing: 0.16 * 42 * scale,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
