import 'package:project/app/constant/widgets/bottom_nav_bar.dart';
import 'package:project/app/controller/services/auth_service.dart';
import 'package:project/app/view/main_screens/lesson_screen.dart';
import 'package:project/app/view/settings_screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:project/app/constant/theme/app_colors.dart';
import 'package:project/app/constant/theme/app_text_style.dart';
import 'package:project/app/constant/widgets/button.dart';
import 'package:project/app/constant/widgets/custom_text_field.dart';
import 'package:project/app/view/authentication/register.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _showPassword = false; // For password visibility toggle

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

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _showSnackBar('Please enter both email and password.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        _showSnackBar('Login Successful!', isError: false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );
      }
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login to account",
                  style: AppTextStyles.headerMedium20.copyWith(
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 50),
                CustomTextFormField(
                  textController: emailController,
                  hintText: "Email",
                  enabled: !_isLoading,
                  obscureText: false,
                  validator: (value) {},
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  textController: passwordController,
                  hintText: "Password",
                  isObscure: !_showPassword, // Use the toggle state
                  enabled: !_isLoading,
                  obscureText: !_showPassword, // Use the toggle state
                  validator: (value) {},
                ),
                const SizedBox(height: 10),
                // Password visibility toggle
                Row(
                  children: [
                    Checkbox(
                      value: _showPassword,
                      onChanged: _isLoading ? null : (value) {
                        setState(() {
                          _showPassword = value ?? false;
                        });
                      },
                      activeColor: AppColors.secondary,
                      checkColor: AppColors.white,
                    ),
                    Text(
                      "Show password",
                      style: AppTextStyles.bodyRegular14.copyWith(
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _isLoading
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
                        onTap: _signInWithEmailAndPassword,
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
      ),
    );
  }
}