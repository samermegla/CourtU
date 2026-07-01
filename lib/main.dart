import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CourtUApp());
}

class CourtUApp extends StatelessWidget {
  const CourtUApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const _AppFlow(),
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
      default:
        return OnboardingScreen(
          onGetStarted: () {},
          onSignIn: () {},
        );
    }
  }
}
