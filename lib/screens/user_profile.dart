import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/logo_wordmark.dart';
import '../widgets/auth_field.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'welcome_screen.dart';

/// Asks a freshly signed-up user what they'd like to be called and saves it as
/// their Firebase display name. The AuthGate routes here whenever a verified
/// account has no display name yet, so this is the last stop before home.
class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _firestoreService = FirestoreService();
  final _nameController = TextEditingController(); //holds the username 
  final _authService = AuthService();
  

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

  Future<void> _handleContinue() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter a name.');
      return;
    }

    setState(() => _isLoading = true);

    //Try block ensures user is authenticated first before writing to database.
    try {
      final user = _authService.currentUser;
      if (user != null) {
        await _firestoreService.createProfile(
          uid: user.uid,
          name: name,
          email: user.email,
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Column(
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
              SizedBox(height: 6.h),
              Text(
                'This is the name your teammates will see.',
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  color: AppColors.mutedForeground,
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
              _GradientButton(
                label: _isLoading ? 'SAVING...' : 'CONTINUE',
                onTap: _isLoading ? null : _handleContinue,
                loading: _isLoading,
              ),
            ],
          ),
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
