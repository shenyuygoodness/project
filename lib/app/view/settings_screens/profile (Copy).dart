// import 'package:project/app/view/authentication/login.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

// import '../../constant/theme/app_colors.dart';
// import '../../constant/theme/app_text_style.dart';
// import '../../constant/widgets/button.dart';
// import '../../constant/widgets/custom_text_field.dart';
//  // <--- IMPORTANT: Ensure this path is correct for your Login screen

// // Let's assume you'll have an 'edit_profile_screen.dart' for updating details.
// // For now, we'll just display them.

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   User? _currentUser; // Firebase Auth user object
//   Map<String, dynamic>? _userData; // Data from Firestore
//   bool _isLoading = true; // To manage loading state for fetching data

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData(); // Fetch user data when the screen initializes
//   }

//   // <--- NEW: Helper function to show a SnackBar message
//   void _showSnackBar(String message, {bool isError = false}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   // Function to fetch user data from Firebase Auth and Firestore
//   Future<void> _fetchUserData() async {
//     setState(() {
//       _isLoading = true; // Start loading
//     });

//     _currentUser = FirebaseAuth.instance.currentUser;

//     if (_currentUser != null) {
//       try {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(_currentUser!.uid)
//             .get();

//         if (userDoc.exists) {
//           _userData = userDoc.data() as Map<String, dynamic>;
//         } else {
//           // If no custom data exists, initialize with a basic map to avoid null errors
//           _userData = {};
//           _showSnackBar('No additional profile data found. Please update your profile.', isError: false);
//         }
//       } catch (e) {
//         _showSnackBar('Error fetching profile data: $e', isError: true);
//         _userData = {}; // Set to empty to prevent errors if fetch fails
//       }
//     } else {
//       _showSnackBar('No user is currently signed in.', isError: true);
//       // If no user, navigate back to login
//       if (mounted) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const Login()),
//         );
//       }
//     }

//     setState(() {
//       _isLoading = false; // Stop loading
//     });
//   }

//   // <--- NEW: Sign Out Function
//   Future<void> _signOut() async {
//     setState(() {
//       _isLoading = true; // Show loading indicator while signing out
//     });
//     try {
//       await FirebaseAuth.instance.signOut();
//       _showSnackBar('Successfully signed out!', isError: false);
//       // Navigate to the login screen and prevent going back to profile
//       if (mounted) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const Login()),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       _showSnackBar('Error signing out: ${e.message}', isError: true);
//     } catch (e) {
//       _showSnackBar('An unexpected error occurred during sign out: $e', isError: true);
//     } finally {
//       setState(() {
//         _isLoading = false; // Stop loading
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primary,
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: Center(
//           child: Text(
//             "My Profile",
//             style: AppTextStyles.bodyBold18.copyWith(color: AppColors.white),
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator(color: AppColors.secondary))
//           : _currentUser == null
//               ? Center(
//                   child: Text(
//                     'Please sign in to view your profile.',
//                     style: AppTextStyles.bodyMedium16.copyWith(color: AppColors.white),
//                   ),
//                 )
//               : ListView(
//                   padding: EdgeInsets.all(15.w),
//                   children: [
//                     SizedBox(height: 20.h),
//                     // Display User Name (from FirebaseAuth or Firestore)
//                     CustomTextFormField(
//                       label: "Name",
//                       hintText: _currentUser?.displayName ?? _userData?['name'] ?? 'N/A',
//                       enabled: false,
//                       textController: TextEditingController(text: _currentUser?.displayName ?? _userData?['name'] ?? 'N/A'),
//                     ),
//                     SizedBox(height: 20.h),
//                     // Display User Email (from FirebaseAuth)
//                     CustomTextFormField(
//                       label: "Email",
//                       hintText: _currentUser?.email ?? 'N/A',
//                       enabled: false,
//                       textController: TextEditingController(text: _currentUser?.email ?? 'N/A'),
//                     ),
//                     SizedBox(height: 20.h),
//                     // Display Status (from Firestore)
//                     CustomTextFormField(
//                       label: "Status",
//                       hintText: _userData?['status'] ?? 'Not set',
//                       enabled: false,
//                       textController: TextEditingController(text: _userData?['status'] ?? 'Not set'),
//                     ),
//                     SizedBox(height: 20.h),
//                     // Display Company/School (from Firestore)
//                     CustomTextFormField(
//                       label: "Company/School",
//                       hintText: _userData?['company'] ?? 'Not set',
//                       enabled: false,
//                       textController: TextEditingController(text: _userData?['company'] ?? 'Not set'),
//                     ),
//                     SizedBox(height: 30.h),
//                     CommonButton(
//                       height: 48.h,
//                       width: double.infinity, // Use full width
//                       onTap: () {
//                         // TODO: Implement navigation to an "Edit Profile" screen here
//                         _showSnackBar('Edit Profile functionality not yet implemented.', isError: false);
//                       },
//                       child: Text(
//                         "Edit Profile",
//                         style: AppTextStyles.bodyBold14.copyWith(color: AppColors.white),
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     CommonButton(
//                       height: 48.h,
//                       width: double.infinity, // Use full width
//                       onTap: _isLoading ? null : _signOut, // Disable button while signing out
//                       child: Text(
//                         "Sign Out",
//                         style: AppTextStyles.bodyBold14.copyWith(color: AppColors.white),
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                   ],
//                 ),
//     );
//   }
// }
