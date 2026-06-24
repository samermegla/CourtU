import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _logoSlideUp = Tween<double>(begin: 100, end: -175).animate(
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
                            width: 150,
                            height: 150,
                            filterQuality: FilterQuality.high,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'CourtU',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Opacity(
                      opacity: _buttonsFade.value,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (_, _, _) =>
                                              const SignUpPage(),
                                      transitionsBuilder: (
                                        _,
                                        animation,
                                        _,
                                        child,
                                      ) =>
                                          FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                      transitionDuration:
                                          const Duration(
                                              milliseconds: 500),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255, 11, 112, 207,
                                  ),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
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
