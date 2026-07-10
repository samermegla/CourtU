import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: Color(0xFF4a5a72),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Back',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: const Color(0xFF4a5a72),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Step progress
                  Row(
                    children: List.generate(3, (i) {
                      final filled = i <= 0;
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: filled ? AppColors.steel : AppColors.dim,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  const LogoWordmark(size: 28),
                  const SizedBox(height: 12),
                  Text(
                    'Create your\naccount',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                      letterSpacing: 0.64,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Join your campus sports community',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable form
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                children: [
                  // SSO
                  SSOBlock(
                    onGoogleSignIn: () {},
                    onUniversitySSO: () {},
                  ),
                  const SizedBox(height: 16),
                  // Full name
                  AuthField(
                    controller: _nameController,
                    icon: const Icon(Icons.person_outline),
                    hintText: 'Full name',
                  ),
                  const SizedBox(height: 10),
                  // Email
                  AuthField(
                    controller: _emailController,
                    icon: const Icon(Icons.school_outlined),
                    hintText: 'uni@university.edu',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
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
                        size: 14,
                        color: const Color(0xFF4a5a72),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Primary sport label
                  Text(
                    'Primary Sport',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: const Color(0xFF4a5a72),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Sport selector
                  Row(
                    children: _Sport.values.map((sport) {
                      final selected = _selectedSport == sport;
                      final color = AppColors.sportColor(sport.name);
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedSport = sport),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? color.withValues(alpha: 0.09)
                                  : AppColors.muted,
                              borderRadius: BorderRadius.circular(12),
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
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _sportLabel[sport]!,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 8,
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
                  const SizedBox(height: 20),
                  // Location consent
                  GestureDetector(
                    onTap: () => setState(() => _locationConsent = !_locationConsent),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.steel.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: _locationConsent
                                  ? AppColors.steel.withValues(alpha: 0.13)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _locationConsent
                                    ? AppColors.steel.withValues(alpha: 0.4)
                                    : AppColors.steel.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: _locationConsent
                                ? const Icon(
                                    Icons.check,
                                    size: 11,
                                    color: AppColors.steelLight,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enable Location Sharing',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'CourtU uses your location to show court activity. Only shared while the app is open.',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11,
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
                  const SizedBox(height: 20),
                  // Create account button
                  _GradientButton(
                    label: _isLoading ? 'CREATING...' : 'CREATE ACCOUNT',
                    onTap: _isLoading ? null : _handleCreateAccount,
                    loading: _isLoading,
                  ),
                  const SizedBox(height: 16),
                  // Terms
                  Text.rich(
                    TextSpan(
                      text: 'By signing up you agree to our ',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else ...[
              Text(
                label,
                style: GoogleFonts.barlowCondensed(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}