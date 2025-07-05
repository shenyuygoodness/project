
// import 'package:project/app/constant/theme/app_text_style.dart';
// import 'package:project/app/constant/utils/asset_strings.dart';
// import 'package:project/app/view/home_screens/home_screen.dart';
// import 'package:project/app/view/main_screens/lesson_screen.dart';
// import 'package:project/app/view/main_screens/settings_screen.dart';
// import 'package:project/app/view/main_screens/threats_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';


// import 'package:flutter/material.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;
//   final List<GlobalKey<NavigatorState>> _navigatorKeys = [
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//   ];

//   void _onItemTapped(int index) {
//     if (_selectedIndex == index) {
//       _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: IndexedStack(
//           index: _selectedIndex,
//           children: _navigatorKeys.map((key) {
//             return Navigator(
//               key: key,
//               onGenerateRoute: (routeSettings) {
//                 return MaterialPageRoute(
//                   builder: (context) {
//                     switch (_navigatorKeys.indexOf(key)) {
//                       case 0:
//                         return const Home();
//                       case 1:
//                         return const LessonScreen();
//                       case 2:
//                         return const ThreatScreen();
//                       case 3:
//                         return const Settings();
//                       default:
//                         return const Home();
//                     }
//                   },
//                 );
//               },
//             );
//           }).toList(),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//             currentIndex: _selectedIndex,
//             onTap: _onItemTapped,
//             elevation: 0,
//             unselectedLabelStyle: AppTextStyles.smallRegular12.copyWith(color: AppColors.black),
//             selectedLabelStyle: AppTextStyles.smallRegular12.copyWith(color: AppColors.primary),
//             unselectedItemColor: AppColors.grey,
//             selectedItemColor: AppColors.primary,
//             type: BottomNavigationBarType.fixed,
//             showSelectedLabels: true,
//             showUnselectedLabels: true,
//             useLegacyColorScheme: true,
//             items:  <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: ImageIcon(
//                   AssetImage(IconsAssets.home),
//                 ),
//                 label: "Home",
//               ),
//               BottomNavigationBarItem(
//                 icon: ImageIcon(
//                   AssetImage(IconsAssets.lesson),
//                 ),
//                 label: "Lessons",
//               ),
//               BottomNavigationBarItem(
//                 icon: ImageIcon(
//                   AssetImage(IconsAssets.threats),
//                 ),
//                 label: "Threat Feeds",

//               ),
//               BottomNavigationBarItem(
//                 icon: ImageIcon(
//                   AssetImage(IconsAssets.settings),
//                 ),
//                 label: "Settings",
//               ),
//             ]));
//   }

// }

