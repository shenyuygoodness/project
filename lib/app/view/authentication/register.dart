import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// <--- NEW: Import Firebase Authentication, Google Sign-In, and Cloud Firestore packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/app/constant/theme/app_colors.dart';
import 'package:project/app/constant/theme/app_text_style.dart';
import 'package:project/app/constant/widgets/button.dart';
import 'package:project/app/constant/widgets/custom_text_field.dart';
import 'package:project/app/view/authentication/login.dart'; // Navigate back to login after email sign up
import 'package:project/app/view/settings_screens/profile.dart'; // Navigate to profile after social sign in

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController statusController;
  late final TextEditingController companyController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    statusController = TextEditingController();
    companyController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    statusController.dispose();
    companyController.dispose();
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

  // <--- UPDATED: Function for Email/Password Sign-Up with Firestore save
  Future<void> _signUpWithEmailAndPassword() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty) {
      _showSnackBar(
        'Please fill in all required fields (Name, Email, Password).',
        isError: true,
      );
      return;
    }
    if (passwordController.text.length < 6) {
      _showSnackBar(
        'Password must be at least 6 characters long.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // Optionally, update the user's display name immediately after creation in Auth
      await userCredential.user?.updateDisplayName(nameController.text.trim());

      // <--- NEW: Save additional user data to Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'name': nameController.text
                  .trim(), // Storing name here for consistency and easy access
              'email': emailController.text.trim(),
              'status': statusController.text.trim(),
              'company': companyController.text.trim(),
              'createdAt':
                  FieldValue.serverTimestamp(), // Useful for analytics/sorting
            });
      }

      if (mounted) {
        _showSnackBar('Account created successfully!', isError: false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ), // Navigate to Login Screen
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage =
              'The password provided is too weak. Please choose a stronger one.';
          break;
        case 'email-already-in-use':
          errorMessage =
              'An account already exists for that email. Please try logging in.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage =
              'Sign Up failed: ${e.message ?? 'An unknown error occurred'}';
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar('An unexpected error occurred: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      // appBar: AppBar(
      //   backgroundColor: AppColors.primary,
      //   title: Center(
      //       child: Text("Sign Up",
      //           style: AppTextStyles.bodyBold18
      //               .copyWith(color: AppColors.white,))),
      // ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(left: 15, right: 15),
          children: [
            SizedBox(height: 20),
            Center(child: Text("Create an Account", style: AppTextStyles.headerMedium20.copyWith(color: AppColors.white))),
            SizedBox(height: 20),
            CustomTextFormField(
              label: "Name",
              textController: nameController,
              hintText: "Enter your full name",
              enabled: !_isLoading,
              obscureText: false,
              validator: (value) {},
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: "Email",
              textController: emailController,
              hintText: "Enter your email",
              enabled: !_isLoading,
              obscureText: false,
              validator: (value) {},
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: "Password",
              textController: passwordController,
              hintText: "Enter your password",
              isObscure: true,
              enabled: !_isLoading,
              obscureText: false,
              validator: (value) {},
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: "Status",
              textController: statusController,
              hintText: "e.g., Student, Professional",
              enabled: !_isLoading,
              obscureText: false,
              validator: (value) {},
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: "Company/School",
              textController: companyController,
              hintText: "Enter your company or school name",
              enabled: !_isLoading,
              obscureText: false,
              validator: (value) {},
            ),
            const SizedBox(height: 30),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  )
                : CommonButton(
                    width: 358,
                    height: 48,
                    child: Text(
                      "Sign Up",
                      style: AppTextStyles.bodyBold14.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    onTap: _signUpWithEmailAndPassword,
                  ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: AppTextStyles.bodyMedium16.copyWith(
                      color: AppColors.tertiary,
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                    child: Text(
                      "Login",
                      style: AppTextStyles.bodyLight16.copyWith(
                        color: AppColors.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
