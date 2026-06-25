import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'signup_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSlideUp;
  late Animation<double> _buttonsFade;
  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _logoSlideUp = Tween<double>(begin: 100.h, end: -125.h).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _buttonsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      _controller.forward();
    });
  }

  void _navigateTo(Widget page) {
    setState(() => _isLeaving = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ).then((_) {
        if (!mounted) return;
        setState(() => _isLeaving = false);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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

          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, _logoSlideUp.value),
                      child: Column(
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
                    ),

                    SizedBox(height: 40.h),

                    AnimatedOpacity(
                      opacity: _isLeaving ? 0 : 1,
                      duration: const Duration(milliseconds: 400),
                      child: Opacity(
                        opacity: _buttonsFade.value,
                        child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: (54.h).clamp(44.0, 64.0),
                              child: ElevatedButton(
                                onPressed: () => _navigateTo(
                                    const SignUpPage()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255, 11, 112, 207,
                                  ),
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
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: double.infinity,
                              height: (54.h).clamp(44.0, 64.0),
                              child: OutlinedButton(
                                onPressed: () => _navigateTo(
                                    const SignUpPage()),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14.r),
                                  ),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
