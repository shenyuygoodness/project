import 'package:project/app/view/authentication/login.dart';
import 'package:project/app/view/authentication/register.dart';
import 'package:project/app/view/details_screens/lesson_details_screens.dart';
import 'package:project/app/view/home_screens/home_screen.dart';
import 'package:project/app/view/main_screens/lesson_screen.dart';
import 'package:project/app/view/main_screens/threats_screen.dart';
import 'package:project/app/view/onboarding/splash_screen.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
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
            home: ThreatScreen(),
          );
        });
  }
}
