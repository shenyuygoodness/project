import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/theme/app_colors.dart';
import '../../constant/theme/app_text_style.dart';
import '../../constant/utils/asset_strings.dart';
import '../../constant/widgets/onboarding_container.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({
    super.key,
  });

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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                // Top spacing
                SizedBox(height: 60.h),
                
                // Image section with enhanced styling
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Background pattern
                            Positioned.fill(
                              child: CustomPaint(
                                painter: IntroBackgroundPainter(),
                              ),
                            ),
                            
                            // Icon placeholder (replace with your image)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120.w,
                                    height: 120.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.greenGradient,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF429690).withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.shield_outlined,
                                      size: 60.sp,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'Threat Intelligence',
                                      style: AppTextStyles.bodyRegular14.copyWith(
                                        color: AppColors.white,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Content section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Title with enhanced styling
                        Text(
                          'Welcome to SecWare',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headerBold24.copyWith(
                            color: AppColors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        
                        SizedBox(height: 16.h),
                        
                        // Subtitle with enhanced styling
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Stay ahead of cyber threats with real-time intelligence, comprehensive learning, and up-to-date security insights.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headerMedium20.copyWith(
                              color: AppColors.tertiary,
                              fontSize: 16.sp,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 30.h),
                        
                        // Feature highlights
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFeatureItem(
                              icon: Icons.trending_up,
                              label: 'Real-time\nUpdates',
                            ),
                            _buildFeatureItem(
                              icon: Icons.school,
                              label: 'Learn &\nGrow',
                            ),
                            _buildFeatureItem(
                              icon: Icons.security,
                              label: 'Stay\nProtected',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom spacing for button
                SizedBox(height: 120.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.tertiary,
            size: 24.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyRegular14.copyWith(
            color: AppColors.tertiary,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

// Custom painter for intro background
class IntroBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw scattered dots
    for (int i = 0; i < 20; i++) {
      double x = (size.width * 0.1) + (i * size.width * 0.05);
      double y = (size.height * 0.1) + ((i * 17) % 100) * (size.height * 0.01);
      canvas.drawCircle(
        Offset(x % size.width, y % size.height),
        2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}