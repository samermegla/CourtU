import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _formFade;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _formFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/people_playing_vb.png',
              fit: BoxFit.cover,
            ),
          ),

          SizedBox.expand(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white70, size: 20.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;
              final logoSectionHeight = 208.h;
              final welcomeColumnHeight =
                  logoSectionHeight + 40.h + 118.h;
              final logoTop = screenHeight / 2 -
                  welcomeColumnHeight / 2 -
                  -125.h;

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: screenHeight),
                  child: Column(
                    children: [
                      SizedBox(height: logoTop),
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 150.w,
                            height: 150.w,
                            filterQuality: FilterQuality.high,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'CourtU',
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _formFade.value,
                            child: child,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w),
                          child: Column(
                            children: [
                              TextField(
                                controller: _firstNameController,
                                style: const TextStyle(
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: const TextStyle(
                                      color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.white
                                      .withValues(alpha: 0.1),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              TextField(
                                controller: _lastNameController,
                                style: const TextStyle(
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: const TextStyle(
                                      color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.white
                                      .withValues(alpha: 0.1),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              TextField(
                                controller: _emailController,
                                keyboardType:
                                    TextInputType.emailAddress,
                                style: const TextStyle(
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  labelStyle: const TextStyle(
                                      color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.white
                                      .withValues(alpha: 0.1),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(
                                    color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                      color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.white
                                      .withValues(alpha: 0.1),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword =
                                            !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              SizedBox(
                                width: double.infinity,
                                height: (54.h).clamp(44.0, 64.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(
                                            255, 11, 112, 207),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              SizedBox(
                                width: double.infinity,
                                height: (54.h).clamp(44.0, 64.0),
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                      Icons.g_mobiledata,
                                      size: 28.sp),
                                  label: Text(
                                      'Sign up with Google'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                        color: Colors.white54),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14.r),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
