import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/app/constant/theme/app_colors.dart';
import 'package:project/app/constant/theme/app_text_style.dart';
import 'package:project/app/constant/widgets/button.dart';
import 'package:project/app/controller/services/auth_service.dart';
import 'package:project/app/view/authentication/login.dart';
import 'package:project/app/view/main_screens/lessons_display.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  bool _isLoggingOut = false;
  late AnimationController _cardAnimationController;
  late AnimationController _headerAnimationController;
  late Animation<double> _cardAnimation;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _cardAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Start animations
    _headerAnimationController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      _cardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _headerAnimationController.dispose();
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar
            SliverAppBar(
              expandedHeight: 120.h,
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.9),
                        AppColors.secondary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: AnimatedBuilder(
                      animation: _headerAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - _headerAnimation.value)),
                          child: Opacity(
                            opacity: _headerAnimation.value,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.greenGradient,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(
                                                0xFF429690,
                                              ).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.security,
                                          color: AppColors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "CyberShield",
                                              style: AppTextStyles.headerBold24
                                                  .copyWith(
                                                    color: AppColors.white,
                                                    fontSize: 24.sp,
                                                  ),
                                            ),
                                            Text(
                                              "Your Cyber Awareness & Threat IntelPlatform",
                                              style: AppTextStyles.bodyRegular14
                                                  .copyWith(
                                                    color: AppColors.tertiary,
                                                    fontSize: 12.sp,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    AnimatedBuilder(
                      animation: _cardAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - _cardAnimation.value)),
                          child: Opacity(
                            opacity: _cardAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.white.withOpacity(0.15),
                                    AppColors.white.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: AppColors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.waving_hand,
                                        color: Colors.amber,
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Welcome back!",
                                        style: AppTextStyles.headerBold24
                                            .copyWith(
                                              color: AppColors.white,
                                              fontSize: 20.sp,
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Stay informed with the latest threat intelligence",
                                    style: AppTextStyles.bodyRegular14.copyWith(
                                      color: AppColors.tertiary,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Learning modules section
                    Text(
                      "Learning Modules",
                      style: AppTextStyles.headerBold24.copyWith(
                        color: AppColors.white,
                        fontSize: 22.sp,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Course cards
                    AnimatedBuilder(
                      animation: _cardAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - _cardAnimation.value)),
                          child: Opacity(
                            opacity: _cardAnimation.value,
                            child: _buildCourseCard(
                              title: "Learn about Trending Threats",
                              description:
                                  "Get started with CyberShield. Learn about threats as they grow.",
                              icon: Icons.school_outlined,
                              gradient: AppColors.greenGradient,
                              delay: 0,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16.h),

                    AnimatedBuilder(
                      animation: _cardAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 70 * (1 - _cardAnimation.value)),
                          child: Opacity(
                            opacity: _cardAnimation.value,
                            child: _buildCourseCard(
                              title: "Advanced Threat Intelligence",
                              description:
                                  "Stay at your A-Game with the latest reported threat feeds and news updates from Pulsedive",
                              icon: Icons.trending_up_outlined,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.blue,
                                  AppColors.blue.withOpacity(0.7),
                                ],
                              ),
                              delay: 200,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Quick stats
                    AnimatedBuilder(
                      animation: _cardAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 90 * (1 - _cardAnimation.value)),
                          child: Opacity(
                            opacity: _cardAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem(
                                    "12K+",
                                    "Threats",
                                    Icons.bug_report,
                                  ),
                                  _buildStatItem(
                                    "24/7",
                                    "Monitoring",
                                    Icons.monitor_heart,
                                  ),
                                  _buildStatItem(
                                    "99%",
                                    "Accuracy",
                                    Icons.verified,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required int delay,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.white.withOpacity(0.15),
            AppColors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.white.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: AppColors.white, size: 24.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.headerBold24.copyWith(
                          color: AppColors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "Learn More",
                          style: AppTextStyles.bodyRegular14.copyWith(
                            color: AppColors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Text(
              description,
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.tertiary,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),

            SizedBox(height: 20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.tertiary,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "real time",
                      style: AppTextStyles.bodyRegular14.copyWith(
                        color: AppColors.tertiary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {  
                        Navigator.push(  
                          context,  
                          MaterialPageRoute(builder: (context) => const LessonsListScreen()),  
                        );
                      },
                      borderRadius: BorderRadius.circular(20.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Start Learning",
                              style: AppTextStyles.bodyBold16.copyWith(
                                color: AppColors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.white,
                              size: 12.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.tertiary, size: 24.sp),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyles.headerBold24.copyWith(
            color: AppColors.white,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.bodyRegular14.copyWith(
            color: AppColors.tertiary,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
