import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/auth_field.dart';
import '../widgets/logo_wordmark.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  const SignInScreen({
    super.key,
    required this.onBack,
    required this.onSignIn,
    required this.onSignUp,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPass = false;
  bool _isLoading = false;
  bool _isSendingReset = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    if (!isValidEmail(email)) {
      _showError('Please enter a valid email address.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signIn(email, password);
      if (user != null && mounted) {
        widget.onSignIn();
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Reuses whatever is already typed in the email field rather than opening a
  /// dialog, so the common case (wrong password, email already filled in) is a
  /// single tap.
  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showError('Enter your email address above, then tap Forgot Password.');
      return;
    }

    if (!isValidEmail(email)) {
      _showError('"$email" doesn\'t look like a valid email address.');
      return;
    }

    setState(() => _isSendingReset = true);

    try {
      await _authService.sendPasswordReset(email);
      if (mounted) {
        // Worded as a conditional on purpose — see sendPasswordReset.
        _showInfo('If an account exists for $email, a reset link is on its way.');
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSendingReset = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: context.colors.steel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
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
                          color: context.colors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Back',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Logo icon + welcome text
                  Row(
                    children: [
                      Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          color: context.colors.surfaceAlt,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: context.colors.steel.withValues(alpha: 0.33),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const LogoMark(size: 30),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back',
                            style: GoogleFonts.poppins(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                              color: context.colors.textPrimary,
                              height: 1.0,
                              letterSpacing: 0.9,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Sign in to Court',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: context.colors.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: 'U',
                                  style: TextStyle(color: context.colors.steelLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Scrollable form
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
                children: [
                  // Email label + field
                  _FieldLabel(text: 'Email'),
                  SizedBox(height: 6.h),
                  AuthField(
                    controller: _emailController,
                    icon: const Icon(Icons.mail_outline),
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    suffix: Icon(
                      Icons.school,
                      size: 14.sp,
                      color: const Color(0x406B9AB8),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Password label + field
                  _FieldLabel(text: 'Password'),
                  SizedBox(height: 6.h),
                  AuthField(
                    controller: _passwordController,
                    icon: const Icon(Icons.lock_outline),
                    hintText: '••••••••',
                    obscureText: !_showPass,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _showPass = !_showPass),
                      child: Icon(
                        _showPass ? Icons.visibility_off : Icons.visibility,
                        size: 14.sp,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _isSendingReset ? null : _handleForgotPassword,
                      child: Text(
                        _isSendingReset
                            ? 'SENDING...'
                            : 'FORGOT PASSWORD?',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _isSendingReset
                              ? context.colors.textSecondary
                              : context.colors.steelLight,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Sign in button
                  _GradientButton(
                    label: _isLoading ? 'SIGNING IN...' : 'SIGN IN',
                    onTap: _isLoading ? null : _handleSignIn,
                    loading: _isLoading,
                  ),
                  SizedBox(height: 16.h),
                  // OR divider
                  _OrDivider(),
                  SizedBox(height: 16.h),
                  // University SSO
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Container(
                        width: 20.r,
                        height: 20.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'G',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1a73e8),
                          ),
                        ),
                      ),
                      label: Text(
                        'Continue with University SSO',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: context.colors.surfaceAlt,
                        side: BorderSide(
                          color: context.colors.steel.withValues(alpha: 0.2),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Sign up prompt
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: context.colors.textSecondary,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: widget.onSignUp,
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: context.colors.steelLight,
                              ),
                            ),
                          ),
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 11.sp,
        letterSpacing: 1,
        color: context.colors.textSecondary,
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: context.colors.steel.withValues(alpha: 0.16)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'OR',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.sp,
              letterSpacing: 2,
              color: context.colors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: context.colors.steel.withValues(alpha: 0.16)),
        ),
      ],
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
              context.colors.steel.withValues(alpha: loading ? 0.6 : 1),
              context.colors.steelLight.withValues(alpha: loading ? 0.6 : 1),
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
                style: GoogleFonts.poppins(
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
