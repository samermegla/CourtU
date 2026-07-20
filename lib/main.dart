import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/verify_email_screen.dart';
import 'screens/profile_setup/profile_setup_data.dart';
import 'screens/profile_setup/profile_setup_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/map_screen.dart';
import 'services/auth_service.dart';
import 'theme/colors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(
    const String.fromEnvironment('MAPBOX_ACCESS_TOKEN'),
  );
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
          home: AuthGate(),
        );
      },
    );
  }
}

/// Derives the top-level UI from Firebase's auth state instead of navigating
/// imperatively: signed out shows the onboarding flow, signed in but
/// unverified is held at the verification screen, verified but new goes
/// through Profile Setup once, then a brief welcome screen before landing
/// on the map.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // userChanges (not authStateChanges) so the gate also rebuilds when a
  // reload() picks up a freshly verified email.
  final Stream<User?> _userChanges = AuthService().userChanges;

  // Session-only: there's no backend field yet to remember that a user has
  // already completed Profile Setup, so this resets on every app restart or
  // re-login. TODO: once a backend exists (e.g. Firestore `users/{uid}`),
  // persist completion (and _profileData) there and read it back here
  // instead of relying on in-memory state.
  bool _profileSetupComplete = false;
  bool _showMap = false;
  ProfileSetupData? _profileData;

  /// Exposed so a future backend-write step has something to read.
  ProfileSetupData? get profileData => _profileData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _userChanges,
      builder: (context, snapshot) {
        // Firebase is still restoring the persisted session from disk.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          // Covers both "never signed in" and "just signed out" (e.g. the
          // dev reset-onboarding button) — either way the next sign-in
          // should go through Profile Setup and Welcome again.
          _profileSetupComplete = false;
          _showMap = false;
          _profileData = null;
          return const _AppFlow();
        }
        if (!user.emailVerified) {
          return const VerifyEmailScreen();
        }
        if (!_profileSetupComplete) {
          return ProfileSetupScreen(
            onComplete: (data) => setState(() {
              _profileData = data;
              _profileSetupComplete = true;
            }),
          );
        }
        if (!_showMap) {
          return WelcomeScreen(
            nickname: _profileData!.nickname,
            onDone: () => setState(() => _showMap = true),
          );
        }
        return const MapScreen();
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
