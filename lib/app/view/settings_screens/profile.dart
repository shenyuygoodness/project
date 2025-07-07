import 'package:project/app/view/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../constant/theme/app_colors.dart';
import '../../constant/theme/app_text_style.dart';
import '../../constant/widgets/button.dart';
import '../../constant/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  
  // Controllers for editable fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Image picker
  // final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();

        if (userDoc.exists) {
          _userData = userDoc.data() as Map<String, dynamic>;
        } else {
          _userData = {};
          _showSnackBar('No additional profile data found. Please update your profile.', isError: false);
        }
        
        // Set controller values
        _nameController.text = _currentUser?.displayName ?? _userData?['name'] ?? '';
        _statusController.text = _userData?['status'] ?? '';
        _companyController.text = _userData?['company'] ?? '';
        _avatarUrl = _userData?['avatarUrl'];
        
      } catch (e) {
        _showSnackBar('Error fetching profile data: $e', isError: true);
        _userData = {};
      }
    } else {
      _showSnackBar('No user is currently signed in.', isError: true);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> _pickImage() async {
  //   // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       // _selectedImage = File(image.path);
  //     });
  //   }
  // }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Update password if provided
      if (_passwordController.text.isNotEmpty) {
        await _currentUser!.updatePassword(_passwordController.text);
      }

      // Update display name
      if (_nameController.text.isNotEmpty) {
        await _currentUser!.updateDisplayName(_nameController.text);
      }

      // Update Firestore data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .set({
        'name': _nameController.text,
        'status': _statusController.text,
        'company': _companyController.text,
        'email': _currentUser!.email,
        'updatedAt': FieldValue.serverTimestamp(),
        if (_avatarUrl != null) 'avatarUrl': _avatarUrl,
      }, SetOptions(merge: true));

      _showSnackBar('Profile updated successfully!', isError: false);
      
      // Clear password fields
      _passwordController.clear();
      _confirmPasswordController.clear();
      
      setState(() {
        _isEditing = false;
      });
      
      // Refresh data
      await _fetchUserData();
      
    } catch (e) {
      _showSnackBar('Error updating profile: $e', isError: true);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signOut();
      _showSnackBar('Successfully signed out!', isError: false);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar('Error signing out: ${e.message}', isError: true);
    } catch (e) {
      _showSnackBar('An unexpected error occurred during sign out: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 4.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 58.w,
            backgroundColor: AppColors.secondary,
            backgroundImage: _selectedImage != null
                ? FileImage(_selectedImage!)
                : _avatarUrl != null
                    ? NetworkImage(_avatarUrl!)
                    : null,
            child: (_selectedImage == null && _avatarUrl == null)
                ? Icon(
                    Icons.person,
                    size: 60.w,
                    color: AppColors.white,
                  )
                : null,
          ),
        ),
        if (_isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: (){},
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2.w),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 18.w,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Name Field
            CustomTextFormField(
              label: "Full Name",
              hintText: "Enter your full name",
              enabled: _isEditing,
              textController: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              }, obscureText: false,
            ),
            SizedBox(height: 20.h),
            
            // Email Field (Read-only)
            CustomTextFormField(
              label: "Email",
              hintText: _currentUser?.email ?? 'N/A',
              enabled: false,
              textController: TextEditingController(text: _currentUser?.email ?? 'N/A'), obscureText: false, validator: (value) {  },
            ),
            SizedBox(height: 20.h),
            
            // Status/Role Field
            CustomTextFormField(
              label: "Role/Status",
              hintText: "Enter your role or status",
              enabled: _isEditing,
              textController: _statusController, obscureText: false, validator: (value) {  },
            ),
            SizedBox(height: 20.h),
            
            // Company/School Field
            CustomTextFormField(
              label: "Company/School",
              hintText: "Enter your company or school",
              enabled: _isEditing,
              textController: _companyController, obscureText: false, validator: (value) {  },
            ),
            
            // Password fields (only show when editing)
            if (_isEditing) ...[
              SizedBox(height: 20.h),
              CustomTextFormField(
                label: "New Password (Optional)",
                hintText: "Enter new password",
                enabled: _isEditing,
                textController: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextFormField(
                label: "Confirm New Password",
                hintText: "Confirm your new password",
                enabled: _isEditing && _passwordController.text.isNotEmpty,
                textController: _confirmPasswordController,
                obscureText: true,
                validator: (value) {
                  if (_passwordController.text.isNotEmpty) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                  }
                  return null;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          if (_isEditing) ...[
            // Save Button
            CommonButton(
              height: 48.h,
              width: double.infinity,
              onTap: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2.w,
                      ),
                    )
                  : Text(
                      "Save Changes",
                      style: AppTextStyles.bodyBold14.copyWith(color: AppColors.white),
                    ),
            ),
            SizedBox(height: 12.h),
            // Cancel Button
            CommonButton(
              height: 48.h,
              width: double.infinity,
              onTap: _isSaving ? null : () {
                setState(() {
                  _isEditing = false;
                  // Reset controllers
                  _nameController.text = _currentUser?.displayName ?? _userData?['name'] ?? '';
                  _statusController.text = _userData?['status'] ?? '';
                  _companyController.text = _userData?['company'] ?? '';
                  _passwordController.clear();
                  _confirmPasswordController.clear();
                  _selectedImage = null;
                });
              },
              child: Text(
                "Cancel",
                style: AppTextStyles.bodyBold14.copyWith(color: AppColors.white),
              ),
            ),
          ] else ...[
            // Edit Button
            CommonButton(
              height: 48.h,
              width: double.infinity,
              onTap: () {
                setState(() {
                  _isEditing = true;
                });
              },
              child: Text(
                "Edit Profile",
                style: AppTextStyles.bodyBold14.copyWith(color: AppColors.white),
              ),
            ),
          ],
          SizedBox(height: 12.h),
          // Sign Out Button
          CommonButton(
            height: 48.h,
            width: double.infinity,
            onTap: _isLoading ? null : _signOut,
            child: Text(
              "Sign Out",
              style: AppTextStyles.bodyBold14.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          "My Profile",
          style: AppTextStyles.bodyBold18.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
        leading: _isEditing
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    _selectedImage = null;
                  });
                },
              )
            : null,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            )
          : _currentUser == null
              ? Center(
                  child: Text(
                    'Please sign in to view your profile.',
                    style: AppTextStyles.bodyMedium16.copyWith(color: AppColors.white),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      
                      // Avatar Section
                      _buildAvatar(),
                      SizedBox(height: 12.h),
                      
                      // User Name
                      Text(
                        _nameController.text.isNotEmpty ? _nameController.text : 'No Name',
                        style: AppTextStyles.bodyBold18.copyWith(color: AppColors.white),
                      ),
                      SizedBox(height: 4.h),
                      
                      // User Status
                      Text(
                        _statusController.text.isNotEmpty ? _statusController.text : 'No Status',
                        style: AppTextStyles.bodyMedium14.copyWith(color: AppColors.white.withOpacity(0.8)),
                      ),
                      SizedBox(height: 30.h),
                      
                      // Profile Card
                      _buildProfileCard(),
                      SizedBox(height: 20.h),
                      
                      // Action Buttons
                      _buildActionButtons(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
    );
  }
}