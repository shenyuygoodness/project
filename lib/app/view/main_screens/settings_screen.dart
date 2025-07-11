import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/app/constant/theme/app_colors.dart';
import 'package:project/app/view/settings_screens/profile.dart';

// class AppColors {
//   static LinearGradient greenGradient = const LinearGradient(colors: [
//     Color(0xFF429690),
//     Color(0xFF2A7C76),
//   ]);
//   static Color primary = const Color(0xFF0F1A24);
//   static Color secondary = const Color(0xFF21364A);
//   static Color blue = const Color(0xFF0D80F2);
//   static Color grey = const Color(0xFF666666);
//   static Color black = const Color(0xFF000000);
//   static Color white = const Color(0xFFFFFFFF);
//   static Color tertiary = const Color(0xFF8FADCC);
  
//   static List<Color> gradientColors = [
//     AppColors.primary,
//     AppColors.secondary,
//   ];
// }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  bool _threatAlerts = false;
  bool _vulnerabilityUpdates = false;
  bool _dailyDigest = false;
  bool _offlineMode = false;
  bool _darkTheme = false;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h, top: 24.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 20.h,
            decoration: BoxDecoration(
              gradient: AppColors.greenGradient,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required Widget child,
    EdgeInsets? padding,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: padding ?? EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCustomSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    IconData? icon,
  }) {
    return _buildSettingCard(
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                gradient: value ? AppColors.greenGradient : null,
                color: value ? null : AppColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 20.w,
              ),
            ),
            SizedBox(width: 16.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.tertiary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50.w,
              height: 28.h,
              decoration: BoxDecoration(
                gradient: value ? AppColors.greenGradient : null,
                color: value ? null : AppColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required VoidCallback onTap,
    IconData? icon,
    String? subtitle,
  }) {
    return _buildSettingCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    gradient: AppColors.greenGradient,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.white,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 16.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.tertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.tertiary,
                size: 16.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      margin: EdgeInsets.only(top: 32.h),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenGradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: _isLoading ? null : () {
            setState(() {
              _isLoading = true;
            });
            // Simulate save operation
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Settings saved successfully!'),
                  backgroundColor: AppColors.greenGradient.colors.first,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            });
          },
          child: Center(
            child: _isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.w,
                    ),
                  )
                : Text(
                    'Save Settings',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
          ),
        ),
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
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20.w),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notifications Section
                _buildSectionTitle('Notifications'),
                _buildCustomSwitch(
                  title: 'Threat Alerts',
                  subtitle: 'Get notified about security threats and vulnerabilities',
                  value: _threatAlerts,
                  onChanged: (value) => setState(() => _threatAlerts = value),
                  icon: Icons.security,
                ),
                _buildCustomSwitch(
                  title: 'Vulnerability Updates',
                  subtitle: 'Receive updates about new security vulnerabilities',
                  value: _vulnerabilityUpdates,
                  onChanged: (value) => setState(() => _vulnerabilityUpdates = value),
                  icon: Icons.update,
                ),
                _buildCustomSwitch(
                  title: 'Daily Digest',
                  subtitle: 'Get daily summary of security events and updates',
                  value: _dailyDigest,
                  onChanged: (value) => setState(() => _dailyDigest = value),
                  icon: Icons.email,
                ),

                // General Section
                _buildSectionTitle('General'),
                _buildCustomSwitch(
                  title: 'Offline Mode',
                  subtitle: 'Access generated lessons without internet connection',
                  value: _offlineMode,
                  onChanged: (value) => setState(() => _offlineMode = value),
                  icon: Icons.offline_bolt,
                ),
                _buildCustomSwitch(
                  title: 'Dark Theme',
                  subtitle: 'Use dark mode for better viewing experience',
                  value: _darkTheme,
                  onChanged: (value) => setState(() => _darkTheme = value),
                  icon: Icons.dark_mode,
                ),

                // Profile Section
                _buildSectionTitle('Account'),
                _buildNavigationTile(
                  title: 'Profile',
                  subtitle: 'Manage your profile and account settings',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
                _buildNavigationTile(
                  title: 'Privacy & Security',
                  subtitle: 'Control your privacy and security settings',
                  icon: Icons.privacy_tip,
                  onTap: () {
                    // TODO: Navigate to privacy settings
                  },
                ),
                _buildNavigationTile(
                  title: 'Help & Support',
                  subtitle: 'Get help or contact support team',
                  icon: Icons.help_outline,
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),

                // Save Button
                _buildSaveButton(),
                
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}