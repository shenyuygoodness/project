import 'package:project/app/controller/services/auth_service.dart';
import 'package:project/app/view/authentication/login.dart';
import 'package:project/app/view/authentication/register.dart';
import 'package:project/app/view/details_screens/lesson_details_screens.dart';
import 'package:project/app/view/home_screens/home_screen.dart';
import 'package:project/app/view/main_screens/lesson_screen.dart';
import 'package:project/app/view/main_screens/threats_screen.dart';
import 'package:project/app/view/onboarding/splash_screen.dart';
import 'package:project/app/view/intro_screens/onbarding.dart';
import 'package:project/app/constant/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/app/view/settings_screens/profile.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: AuthWrapper(),
          routes: {
            '/splash': (context) => SplashScreen(),
            '/onboarding': (context) => Onboarding(),
            '/login': (context) => Login(),
            '/register': (context) => SignUp(),
            '/home': (context) => BottomNavBar(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Widget? _initialScreen;

  @override
  void initState() {
    super.initState();
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    try {
      // Show splash screen for a minimum time
      await Future.delayed(Duration(seconds: 2));
      
      final bool isFirstTime = await _authService.isFirstTimeUser();
      final bool onboardingCompleted = await _authService.isOnboardingCompleted();
      final bool authenticated = _authService.isAuthenticated;

      Widget initialScreen;

      if (isFirstTime || !onboardingCompleted) {
        // First time user or onboarding not completed
        initialScreen = Onboarding();
      } else if (authenticated) {
        // User is authenticated and onboarding is completed
        initialScreen = BottomNavBar();
      } else {
        // User is not authenticated but onboarding is completed
        initialScreen = Login();
      }

      if (mounted) {
        setState(() {
          _initialScreen = initialScreen;
          _isLoading = false;
        });
      }
    } catch (e) {
      // In case of error, show onboarding
      if (mounted) {
        setState(() {
          _initialScreen = Onboarding();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SplashScreen();
    }

    return _initialScreen ?? SplashScreen();
  }
}