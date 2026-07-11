import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/auth_field.dart';
import '../widgets/logo_wordmark.dart';

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
  bool _showPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  SizedBox(height: 24.h),
                  // Logo icon + welcome text
                  Row(
                    children: [
                      Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.steel.withValues(alpha: 0.33),
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
                            style: GoogleFonts.barlowCondensed(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.0,
                              letterSpacing: 0.9,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Sign in to Court',
                              style: GoogleFonts.dmSans(
                                fontSize: 12.sp,
                                color: AppColors.mutedForeground,
                              ),
                              children: [
                                TextSpan(
                                  text: 'U',
                                  style: TextStyle(color: AppColors.steelLight),
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
                  _FieldLabel(text: 'University Email'),
                  SizedBox(height: 6.h),
                  AuthField(
                    icon: const Icon(Icons.mail_outline),
                    hintText: 'you@university.edu',
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
                    icon: const Icon(Icons.lock_outline),
                    hintText: '••••••••',
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
                  SizedBox(height: 8.h),
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'FORGOT PASSWORD?',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.steelLight,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Sign in button
                  _GradientButton(
                    label: 'SIGN IN',
                    onTap: widget.onSignIn,
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
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.muted,
                        side: BorderSide(
                          color: AppColors.steel.withValues(alpha: 0.2),
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
                      style: GoogleFonts.dmSans(
                        fontSize: 12.sp,
                        color: const Color(0xFF4a5a72),
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: widget.onSignUp,
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.dmSans(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.steelLight,
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
        color: const Color(0xFF4a5a72),
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
          child: Container(height: 1, color: AppColors.steel.withValues(alpha: 0.16)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'OR',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.sp,
              letterSpacing: 2,
              color: const Color(0xFF4a5a72),
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: AppColors.steel.withValues(alpha: 0.16)),
        ),
      ],
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
      child: Container(
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
    );
  }
}
