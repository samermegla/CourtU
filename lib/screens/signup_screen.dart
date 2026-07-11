import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/logo_wordmark.dart';
import '../widgets/auth_field.dart';
import '../widgets/sso_block.dart';
import '../services/auth_service.dart';

enum _Sport { volleyball, basketball, tennis, badminton, pickleball }

const _sportEmoji = {
  _Sport.volleyball: '🏐',
  _Sport.basketball: '🏀',
  _Sport.tennis: '🎾',
  _Sport.badminton: '🏸',
  _Sport.pickleball: '🏓',
};

const _sportLabel = {
  _Sport.volleyball: 'VOLL',
  _Sport.basketball: 'BASK',
  _Sport.tennis: 'TENN',
  _Sport.badminton: 'BADM',
  _Sport.pickleball: 'PICK',
};

class SignUpScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onCreateAccount;

  const SignUpScreen({
    super.key,
    required this.onBack,
    required this.onCreateAccount,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authService = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPass = false;
  bool _isLoading = false;
  _Sport? _selectedSport;
  bool _locationConsent = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter an email and password.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signUp(email, password);
      if (user != null && mounted) {
        widget.onCreateAccount();
      }
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
        child: Column(
          children: [
            // Header section
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chevron_right,
                          size: 14.sp,
                          color: const Color(0xFF4a5a72),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Back',
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            color: const Color(0xFF4a5a72),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Step progress
                  Row(
                    children: List.generate(3, (i) {
                      final filled = i <= 0;
                      return Expanded(
                        child: Container(
                          height: 4.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            color: filled ? AppColors.steel : AppColors.dim,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),
                  const LogoWordmark(size: 28),
                  SizedBox(height: 12.h),
                  Text(
                    'Create your\naccount',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                      letterSpacing: 0.64,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Join your campus sports community',
                    style: GoogleFonts.dmSans(
                      fontSize: 14.sp,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable form
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
                children: [
                  // SSO
                  SSOBlock(
                    onGoogleSignIn: () {},
                    onUniversitySSO: () {},
                  ),
                  SizedBox(height: 16.h),
                  // Full name
                  AuthField(
                    controller: _nameController,
                    icon: const Icon(Icons.person_outline),
                    hintText: 'Full name',
                  ),
                  SizedBox(height: 10.h),
                  // Email
                  AuthField(
                    controller: _emailController,
                    icon: const Icon(Icons.school_outlined),
                    hintText: 'uni@university.edu',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10.h),
                  // Password
                  AuthField(
                    controller: _passwordController,
                    icon: const Icon(Icons.lock_outline),
                    hintText: 'Password',
                    obscureText: !_showPass,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _showPass = !_showPass),
                      child: Icon(
                        _showPass ? Icons.visibility_off : Icons.visibility,
                        size: 14.sp,
                        color: const Color(0xFF4a5a72),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Primary sport label
                  Text(
                    'Primary Sport',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.sp,
                      letterSpacing: 1.2,
                      color: const Color(0xFF4a5a72),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Sport selector
                  Row(
                    children: _Sport.values.map((sport) {
                      final selected = _selectedSport == sport;
                      final color = AppColors.sportColor(sport.name);
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedSport = sport),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: selected
                                  ? color.withValues(alpha: 0.09)
                                  : AppColors.muted,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: selected
                                    ? color
                                    : AppColors.steel.withValues(alpha: 0.16),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _sportEmoji[sport]!,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _sportLabel[sport]!,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                    color: selected
                                        ? color
                                        : const Color(0xFF4a5a72),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  // Location consent
                  GestureDetector(
                    onTap: () => setState(() => _locationConsent = !_locationConsent),
                    child: Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.steel.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20.r,
                            height: 20.r,
                            margin: EdgeInsets.only(top: 2.h),
                            decoration: BoxDecoration(
                              color: _locationConsent
                                  ? AppColors.steel.withValues(alpha: 0.13)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: _locationConsent
                                    ? AppColors.steel.withValues(alpha: 0.4)
                                    : AppColors.steel.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: _locationConsent
                                ? Icon(
                                    Icons.check,
                                    size: 11.sp,
                                    color: AppColors.steelLight,
                                  )
                                : null,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enable Location Sharing',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'CourtU uses your location to show court activity. Only shared while the app is open.',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11.sp,
                                    height: 1.4,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Create account button
                  _GradientButton(
                    label: _isLoading ? 'CREATING...' : 'CREATE ACCOUNT',
                    onTap: _isLoading ? null : _handleCreateAccount,
                    loading: _isLoading,
                  ),
                  SizedBox(height: 16.h),
                  // Terms
                  Text.rich(
                    TextSpan(
                      text: 'By signing up you agree to our ',
                      style: GoogleFonts.dmSans(
                        fontSize: 10.sp,
                        color: const Color(0xFF4a5a72),
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms',
                          style: TextStyle(color: AppColors.steelLight),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: AppColors.steelLight),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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
