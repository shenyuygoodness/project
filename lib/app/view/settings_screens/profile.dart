import 'package:project/app/view/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
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
  
  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _avatarAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  File? _selectedImage;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchUserData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _avatarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _avatarAnimationController.dispose();
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
        backgroundColor: isError ? Colors.red.shade700 : AppColors.greenGradient.colors.first,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
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

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (_passwordController.text.isNotEmpty) {
        await _currentUser!.updatePassword(_passwordController.text);
      }

      if (_nameController.text.isNotEmpty) {
        await _currentUser!.updateDisplayName(_nameController.text);
      }

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
      
      _passwordController.clear();
      _confirmPasswordController.clear();
      
      setState(() {
        _isEditing = false;
      });
      
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
    // Show confirmation dialog
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
            color: AppColors.tertiary,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.tertiary,
                fontSize: 14.sp,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.greenGradient,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
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
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          // Avatar with animation
          ScaleTransition(
            scale: _scaleAnimation,
            child: _buildAvatar(),
          ),
          SizedBox(height: 20.h),
          
          // User info
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Text(
                  _nameController.text.isNotEmpty ? _nameController.text : 'No Name',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: AppColors.greenGradient,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _statusController.text.isNotEmpty ? _statusController.text : 'Add Status',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  _companyController.text.isNotEmpty ? _companyController.text : 'Add Company',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.greenGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.greenGradient.colors.first.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary,
            ),
            child: CircleAvatar(
              radius: 56.w,
              backgroundColor: AppColors.secondary,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : _avatarUrl != null
                      ? NetworkImage(_avatarUrl!)
                      : null,
              child: (_selectedImage == null && _avatarUrl == null)
                  ? Icon(
                      Icons.person,
                      size: 50.w,
                      color: AppColors.tertiary,
                    )
                  : null,
            ),
          ),
        ),
        if (_isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // Image picker implementation
                _avatarAnimationController.forward().then((_) {
                  _avatarAnimationController.reverse();
                });
              },
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  gradient: AppColors.greenGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greenGradient.colors.first.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 20.w,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEnhancedTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool enabled,
    bool obscureText = false,
    String? Function(String?)? validator,
    IconData? prefixIcon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            enabled: enabled,
            obscureText: obscureText,
            validator: validator,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16.sp,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.tertiary.withOpacity(0.7),
                fontSize: 14.sp,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: enabled ? AppColors.greenGradient.colors.first : AppColors.tertiary,
                      size: 20.w,
                    )
                  : null,
              filled: true,
              fillColor: enabled ? AppColors.secondary : AppColors.secondary.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.tertiary.withOpacity(0.3),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.greenGradient.colors.first,
                  width: 2.w,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildEnhancedTextField(
              label: "Full Name",
              hint: "Enter your full name",
              controller: _nameController,
              enabled: _isEditing,
              prefixIcon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            
            _buildEnhancedTextField(
              label: "Email",
              hint: _currentUser?.email ?? 'N/A',
              controller: TextEditingController(text: _currentUser?.email ?? 'N/A'),
              enabled: false,
              prefixIcon: Icons.email_outlined,
            ),
            
            _buildEnhancedTextField(
              label: "Role/Status",
              hint: "Enter your role or status",
              controller: _statusController,
              enabled: _isEditing,
              prefixIcon: Icons.work_outline,
            ),
            
            _buildEnhancedTextField(
              label: "Company/School",
              hint: "Enter your company or school",
              controller: _companyController,
              enabled: _isEditing,
              prefixIcon: Icons.business_outlined,
            ),
            
            if (_isEditing) ...[
              _buildEnhancedTextField(
                label: "New Password (Optional)",
                hint: "Enter new password",
                controller: _passwordController,
                enabled: _isEditing,
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              
              _buildEnhancedTextField(
                label: "Confirm New Password",
                hint: "Confirm your new password",
                controller: _confirmPasswordController,
                enabled: _isEditing && _passwordController.text.isNotEmpty,
                obscureText: true,
                prefixIcon: Icons.lock_outline,
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

  Widget _buildEnhancedButton({
    required String text,
    required VoidCallback? onTap,
    required bool isPrimary,
    bool isLoading = false,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      height: 56.h,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: isPrimary ? AppColors.greenGradient : null,
              color: isPrimary ? null : AppColors.secondary,
              borderRadius: BorderRadius.circular(16.r),
              border: isPrimary ? null : Border.all(
                color: AppColors.tertiary.withOpacity(0.3),
                width: 1.w,
              ),
              boxShadow: isPrimary ? [
                BoxShadow(
                  color: AppColors.greenGradient.colors.first.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ] : null,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2.w,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: AppColors.white,
                            size: 20.w,
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          if (_isEditing) ...[
            _buildEnhancedButton(
              text: "Save Changes",
              onTap: _isSaving ? null : _saveProfile,
              isPrimary: true,
              isLoading: _isSaving,
              icon: Icons.save,
            ),
            _buildEnhancedButton(
              text: "Cancel",
              onTap: _isSaving ? null : () {
                setState(() {
                  _isEditing = false;
                  _nameController.text = _currentUser?.displayName ?? _userData?['name'] ?? '';
                  _statusController.text = _userData?['status'] ?? '';
                  _companyController.text = _userData?['company'] ?? '';
                  _passwordController.clear();
                  _confirmPasswordController.clear();
                  _selectedImage = null;
                });
              },
              isPrimary: false,
              icon: Icons.cancel,
            ),
          ] else ...[
            _buildEnhancedButton(
              text: "Edit Profile",
              onTap: () {
                setState(() {
                  _isEditing = true;
                });
              },
              isPrimary: true,
              icon: Icons.edit,
            ),
          ],
          _buildEnhancedButton(
            text: "Sign Out",
            onTap: _isLoading ? null : _signOut,
            isPrimary: false,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  // Widget _buildStatsCard() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
  //     padding: EdgeInsets.all(20.w),
  //     decoration: BoxDecoration(
  //       color: AppColors.secondary,
  //       borderRadius: BorderRadius.circular(16.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         _buildStatItem("Security Score", "92%", Icons.security),
  //         Container(
  //           width: 1.w,
  //           height: 40.h,
  //           color: AppColors.tertiary.withOpacity(0.3),
  //         ),
  //         _buildStatItem("Threats Blocked", "247", Icons.block),
  //         Container(
  //           width: 1.w,
  //           height: 40.h,
  //           color: AppColors.tertiary.withOpacity(0.3),
  //         ),
  //         _buildStatItem("Last Scan", "2h ago", Icons.schedule),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildStatItem(String label, String value, IconData icon) {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.all(8.w),
  //         decoration: BoxDecoration(
  //           gradient: AppColors.greenGradient,
  //           borderRadius: BorderRadius.circular(8.r),
  //         ),
  //         child: Icon(
  //           icon,
  //           color: AppColors.white,
  //           size: 20.w,
  //         ),
  //       ),
  //       SizedBox(height: 8.h),
  //       Text(
  //         value,
  //         style: TextStyle(
  //           fontSize: 16.sp,
  //           fontWeight: FontWeight.w700,
  //           color: AppColors.white,
  //         ),
  //       ),
  //       SizedBox(height: 4.h),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 10.sp,
  //           color: AppColors.tertiary,
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        leading: _isEditing
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20.w),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    _selectedImage = null;
                  });
                },
              )
            : IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20.w),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.greenGradient.colors.first,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading profile...',
                    style: TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            )
          : _currentUser == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off,
                        size: 64.w,
                        color: AppColors.tertiary,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Please sign in to view your profile.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Profile Header
                          _buildProfileHeader(),
                          
                          // Stats Card
                          // _buildStatsCard(),
                          
                          // Profile Form
                          _buildProfileForm(),
                          
                          // Action Buttons
                          _buildActionButtons(),
                          
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}