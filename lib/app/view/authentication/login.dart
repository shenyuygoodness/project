import 'package:project/app/view/main_screens/lesson_screen.dart';
import 'package:project/app/view/settings_screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// <--- NEW: Import Firebase Authentication and Google Sign-In packages
import 'package:firebase_auth/firebase_auth.dart';

import 'package:project/app/constant/theme/app_colors.dart';
import 'package:project/app/constant/theme/app_text_style.dart';
import 'package:project/app/constant/widgets/button.dart';
import 'package:project/app/constant/widgets/custom_text_field.dart';
import 'package:project/app/view/authentication/register.dart';
// <--- NEW: Import your home screen or the screen to navigate to after successful login
//import 'package:project/app/home_screen.dart'; // <--- IMPORTANT: Adjust this path to your actual home screen!

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // <--- NEW: Controllers moved inside the State class for proper lifecycle management
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  // <--- NEW: State variable to manage loading indicator
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // <--- NEW: Helper function to show a SnackBar message
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; // Ensure the widget is still in the tree
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // <--- NEW: Function for Email/Password Sign-In
  Future<void> _signInWithEmailAndPassword() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _showSnackBar('Please enter both email and password.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // If successful, navigate to the home screen
      if (mounted) {
        _showSnackBar('Login Successful!', isError: false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LessonScreen(),
          ), // Navigate to your home screen
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage =
              'No user found for that email. Please check your credentials or sign up.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage =
              'Too many failed login attempts. Please try again later.';
          break;
        default:
          errorMessage =
              'Login failed: ${e.message ?? 'An unknown error occurred'}';
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar('An unexpected error occurred: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Center(
          child: Text(
            "Login",
            style: AppTextStyles.bodyBold18.copyWith(color: AppColors.white),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login to account", style: AppTextStyles.headerMedium20.copyWith(
                color: AppColors.white,
              ),),
              SizedBox(height: 50),
              CustomTextFormField(
                textController: emailController,
                hintText: "Email",
                enabled: !_isLoading, obscureText: false, validator: (value) {  }, // Disable input when loading
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                textController: passwordController,
                hintText: "Password",
                isObscure: true, // Typically passwords should be obscured
                enabled: !_isLoading, obscureText: false, validator: (value) {  }, // Disable input when loading
              ),
              const SizedBox(height: 30),
              _isLoading // <--- NEW: Show CircularProgressIndicator when loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.secondary,
                      ),
                    )
                  : CommonButton(
                      height: 48.h,
                      width: 327.w,
                      child: Text(
                        "Login",
                        style: AppTextStyles.bodyBold14.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      onTap:
                          _signInWithEmailAndPassword, // <--- NEW: Call the email/password login function
                    ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: AppTextStyles.bodyMedium16.copyWith(
                      color: AppColors.tertiary,
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            // <--- NEW: Disable when loading
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            );
                          },
                    child: Text(
                      "Sign Up",
                      style: AppTextStyles.bodyLight14.copyWith(
                        color: AppColors.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lets start all over. Create a check box with text "Show password" below the password text field for the login screen. when it is checked the users password being inputed is visible else it is obscure