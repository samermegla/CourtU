import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/logo_wordmark.dart';
import '../widgets/auth_field.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';

//Skin tones
const List<Color> skinTones = [
  Color(0xFFF8D5C2),
  Color(0xFFF0C0A0),
  Color(0xFFD9A066),
  Color(0xFFB07A4B),
  Color(0xFF8D5524),
  Color(0xFF5A3720),
];

const List<Color> jerseyColors = [
  AppColors.steel,
  AppColors.accent,
  AppColors.green,
  Color(0xFF3b82f6),
  Color(0xFFa855f7),
  Color(0xFFf59e0b),
  Color(0xFFef4444),
  Colors.white,
];

class HatOption {
  final String id;
  final String emoji;
  final String label;
  const HatOption(this.id, this.emoji, this.label);
}

const List<HatOption> hats = [
  HatOption('none', '', 'None'),
  HatOption('cap', '🧢', 'Cap'),
  HatOption('tophat', '🎩', 'Top hat'),
  HatOption('sun', '👒', 'Sun'),
  HatOption('helmet', '⛑️', 'Helmet'),
  HatOption('grad', '🎓', 'Grad'),
];


const List<String> positions = [
  'Outside Hitter',
  'Middle Blocker',
  'Right Side',
  'Libero / Defensive Specialist',
  'Setter',
  'Not sure yet',
];

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _firestoreService = FirestoreService();
  final _nameController = TextEditingController(); //holds the username
  final _authService = AuthService();

  int _step = 0;

  Color _skin = skinTones[1];
  Color _jersey = jerseyColors[0];
  String _hat = hats.first.id;

  String? _position;

  bool _isLoading = false;

  // Once set, the greeting transition takes over the whole screen. We hold the
  // name locally because the display name isn't saved until the welcome
  // animation finishes (saving it flips the AuthGate away from here).
  bool _showWelcome = false;
  String _welcomeName = '';

  @override
  void dispose() { //method that runs once user leaves screen
    _nameController.dispose();
    super.dispose();
  }

  // Step 0 → step 1. Validates the name but doesn't persist anything yet.
  void _handleNameContinue() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Please enter a name.');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _step = 1);
  }

  // Step 1 → step 2. The puck is held in state until the final save.
  void _handlePuckContinue() => setState(() => _step = 2);

  // Step 2 → welcome transition. Persists the whole profile (name + puck +
  // position), then hands off to the greeting, which saves the display name
  // when done.
  Future<void> _handleFinish() async {
    final name = _nameController.text.trim();
    setState(() => _isLoading = true);

    //Try block ensures user is authenticated first before writing to database.
    try {
      final user = _authService.currentUser;
      if (user != null) {
        await _firestoreService.createProfile(
          uid: user.uid,
          name: name,
          email: user.email,
          skinColor: _skin.toARGB32(),
          jerseyColor: _jersey.toARGB32(),
          hat: _hat,
          position: _position,
        );
      }

      // Hand off to the welcome transition. It saves the display name when its
      // fade-out finishes, which makes userChanges emit and lets the AuthGate
      // swap this screen for whatever comes next.
      if (mounted) {
        setState(() {
          _welcomeName = name;
          _showWelcome = true;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (mounted) _showError(e.toString());
    }
  }

  // Fired once the greeting has faded out. Saving the display name is the last
  // step of the flow — the AuthGate rebuilds away from this screen after it.
  Future<void> _finishWelcome() async {
    try {
      await _authService.updateDisplayName(_welcomeName);
    } catch (e) {
      if (mounted) {
        setState(() {
          _showWelcome = false;
          _isLoading = false;
        });
        _showError(e.toString());
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      return WelcomeScreen(username: _welcomeName, onComplete: _finishWelcome);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      // Let the system/back gesture step back to the name slide instead of
      // leaving the onboarding flow entirely.
      body: PopScope(
        canPop: _step == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _step > 0) setState(() => _step--);
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: switch (_step) {
              0 => _buildNameStep(),
              1 => _buildPuckStep(),
              _ => _buildPositionStep(),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        const LogoWordmark(size: 28),
        SizedBox(height: 28.h),
        SizedBox(
          width: double.infinity,
          child: Text(
            'What should we call you?',
            textAlign: TextAlign.center,
            style: GoogleFonts.barlowCondensed(
              fontSize: 32.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
              letterSpacing: 0.64,
            ),
          ),
        ),
        SizedBox(height: 28.h),
        AuthField(
          controller: _nameController,
          icon: const Icon(Icons.person_outline),
          hintText: 'Your name',
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 24.h),
        _GradientButton(label: 'CONTINUE', onTap: _handleNameContinue),
      ],
    );
  }

  Widget _buildPuckStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 12.h),
        _backHeader(),
        SizedBox(height: 20.h),
        Text(
          'make it yours',
          textAlign: TextAlign.center,
          style: GoogleFonts.barlowCondensed(
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.0,
            letterSpacing: 0.64,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Build the player others see on the map.',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 14.sp,
            color: AppColors.mutedForeground,
          ),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: PlayerPuck(
                    size: 120.r,
                    skin: _skin,
                    jersey: _jersey,
                    hatEmoji: _hatEmoji(_hat),
                  ),
                ),
                SizedBox(height: 28.h),
                _section(
                  'Skin',
                  Wrap(
                    spacing: 14.w,
                    runSpacing: 14.h,
                    children: [
                      for (final color in skinTones)
                        _ColorSwatch(
                          color: color,
                          selected: color == _skin,
                          onTap: () => setState(() => _skin = color),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                _section(
                  'Jersey',
                  Wrap(
                    spacing: 14.w,
                    runSpacing: 14.h,
                    children: [
                      for (final color in jerseyColors)
                        _ColorSwatch(
                          color: color,
                          selected: color == _jersey,
                          onTap: () => setState(() => _jersey = color),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                _section(
                  'Hat',
                  Wrap(
                    spacing: 14.w,
                    runSpacing: 14.h,
                    children: [
                      for (final option in hats)
                        _HatChoice(
                          option: option,
                          selected: option.id == _hat,
                          onTap: () => setState(() => _hat = option.id),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
        _GradientButton(label: 'CONTINUE', onTap: _handlePuckContinue),
      ],
    );
  }

  Widget _buildPositionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 12.h),
        _backHeader(),
        SizedBox(height: 20.h),
        Text(
          'what position do you play?',
          textAlign: TextAlign.center,
          style: GoogleFonts.barlowCondensed(
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.0,
            letterSpacing: 0.64,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Pick the spot you play most.',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 14.sp,
            color: AppColors.mutedForeground,
          ),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final position in positions) ...[
                  _ChoiceRow(
                    label: position,
                    selected: position == _position,
                    onTap: () => setState(() => _position = position),
                  ),
                  SizedBox(height: 12.h),
                ],
              ],
            ),
          ),
        ),
        _GradientButton(
          label: _isLoading ? 'SAVING...' : 'CONTINUE',
          // Require a choice before finishing.
          onTap: (_isLoading || _position == null) ? null : _handleFinish,
          loading: _isLoading,
        ),
      ],
    );
  }

  // Shared top row with a back arrow (steps back one slide) and the wordmark.
  Widget _backHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _step--),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.foreground,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 12.w),
        const LogoWordmark(size: 28),
      ],
    );
  }

  // A left-aligned section label above its row of choices.
  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.barlowCondensed(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.foreground,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }

  String _hatEmoji(String id) =>
      hats.firstWhere((h) => h.id == id).emoji;
}

/// The circular player puck: a jersey-colored body under a skin-colored head,
/// with an optional hat on top. Reused by the map to render each player.
class PlayerPuck extends StatelessWidget {
  final double size;
  final Color skin;
  final Color jersey;
  final String hatEmoji;
  final Color background;

  const PlayerPuck({
    super.key,
    required this.size,
    required this.skin,
    required this.jersey,
    required this.hatEmoji,
    this.background = AppColors.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: size * 0.12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Jersey (shoulders) anchored to the bottom.
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size * 0.74,
                height: size * 0.44,
                decoration: BoxDecoration(
                  color: jersey,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(size * 0.37),
                  ),
                ),
              ),
            ),
            // Head.
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: size * 0.15),
                child: Container(
                  width: size * 0.46,
                  height: size * 0.46,
                  decoration: BoxDecoration(
                    color: skin,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Hat sits on top of the head.
            if (hatEmoji.isNotEmpty)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.02),
                  child: Text(
                    hatEmoji,
                    style: TextStyle(fontSize: size * 0.30),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A single selectable color swatch.
class _ColorSwatch extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.white : Colors.white.withValues(alpha: 0.15),
            width: selected ? 3 : 1,
          ),
        ),
        child: selected
            ? Icon(
                Icons.check,
                size: 20.sp,
                color: ThemeData.estimateBrightnessForColor(color) ==
                        Brightness.dark
                    ? Colors.white
                    : Colors.black,
              )
            : null,
      ),
    );
  }
}

/// A single selectable hat, shown as its emoji (or a "no hat" glyph) with a
/// label beneath.
class _HatChoice extends StatelessWidget {
  final HatOption option;
  final bool selected;
  final VoidCallback onTap;

  const _HatChoice({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.muted,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.steelLight : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: option.emoji.isEmpty
                ? Icon(
                    Icons.block,
                    size: 22.sp,
                    color: AppColors.mutedForeground,
                  )
                : Text(option.emoji, style: TextStyle(fontSize: 24.sp)),
          ),
          SizedBox(height: 4.h),
          Text(
            option.label,
            style: GoogleFonts.dmSans(
              fontSize: 11.sp,
              color: selected ? AppColors.foreground : AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

/// A full-width selectable option row (used for position and competitiveness).
class _ChoiceRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.dim : AppColors.muted,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? AppColors.steelLight : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: AppColors.steelLight, size: 22.sp),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;

  const _GradientButton({
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.steel.withValues(alpha: loading ? 0.6 : 1),
              AppColors.steelLight.withValues(alpha: loading ? 0.6 : 1),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              SizedBox(
                width: 16.r,
                height: 16.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else ...[
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
          ],
        ),
      ),
    );
  }
}
