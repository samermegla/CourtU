import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/signin_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(const CourtUApp());
}

class CourtUApp extends StatelessWidget {
  const CourtUApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The whole app is authored against this reference frame (iPhone X logical
    // size). ScreenUtil scales every `.w/.h/.sp/.r` unit relative to it so the
    // layout keeps the same proportions on any physical device.
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'CourtU',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF080d18),
            colorScheme: const ColorScheme.dark(
              surface: Color(0xFF080d18),
              primary: Color(0xFF4B6D8A),
              secondary: Color(0xFF1ddf64),
            ),
          ),
          // Clamp the OS text-scale so extreme accessibility font sizes can't
          // push tightly-designed screens into overflow.
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(
                textScaler: mq.textScaler.clamp(
                  minScaleFactor: 1.0,
                  maxScaleFactor: 1.2,
                ),
              ),
              child: child!,
            );
          },
          home: const _AppFlow(),
        );
      },
    );
  }
}

class _AppFlow extends StatefulWidget {
  const _AppFlow();

  @override
  State<_AppFlow> createState() => _AppFlowState();
}

class _AppFlowState extends State<_AppFlow> {
  String _screen = 'splash';

  void _goTo(String screen) {
    if (!mounted) return;
    setState(() => _screen = screen);
  }

  @override
  Widget build(BuildContext context) {
    switch (_screen) {
      case 'splash':
        return SplashScreen(onComplete: () => _goTo('onboarding'));
      case 'onboarding':
        return OnboardingScreen(
          onGetStarted: () => _goTo('signup'),
          onSignIn: () => _goTo('signin'),
        );
      case 'signup':
        return SignUpScreen(
          onBack: () => _goTo('onboarding'),
          onCreateAccount: () {},
        );
      case 'signin':
        return SignInScreen(
          onBack: () => _goTo('onboarding'),
          onSignIn: () {},
          onSignUp: () => _goTo('signup'),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
