import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/logo_wordmark.dart';
import '../widgets/auth_field.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

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

      // Saving the display name makes userChanges emit, so the AuthGate swaps
      // this screen for home on its own — nothing to navigate here.
      await _authService.updateDisplayName(name);
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                'What should we call you?',
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
