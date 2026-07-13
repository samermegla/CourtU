import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/home_screen.dart';


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
          home: const AuthGate(),
        );
      },
    );
  }
}

/// The single source of truth for "logged in or not."
///
/// It listens to [AuthService.authStateChanges] — a live stream that emits a
/// [User] when someone is signed in and `null` when they aren't. A
/// [StreamBuilder] rebuilds this widget every time that stream emits, so the
/// screen the user sees is always a direct reflection of the auth state. No
/// screen ever has to manually "navigate to home after login" — the gate does
/// it, because the login *causes* the stream to emit.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // First frame, before the stream has told us anything yet. Firebase is
        // checking the device for a saved session. It's brief — show a blank
        // dark screen so we don't flash the login UI at a user who's already
        // signed in.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ColoredBox(color: Color(0xFF080d18));
        }

        // Stream emitted a real user → they're authenticated. Show the app.
        if (snapshot.hasData) {
          return HomeScreen(user: snapshot.data!);
        }

        // Stream emitted null → nobody is signed in. Show the logged-out flow
        // (splash → onboarding → sign in / sign up).
        return const _AppFlow();
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
