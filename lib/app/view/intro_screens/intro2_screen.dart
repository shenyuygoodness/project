import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/theme/app_colors.dart';
import '../../constant/theme/app_text_style.dart';
import '../../constant/utils/asset_strings.dart';
import '../../constant/widgets/onboarding_container.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

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
                                painter: Intro2BackgroundPainter(),
                              ),
                            ),

                            // Main content
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Central illustration
                                  Container(
                                    width: 160.w,
                                    height: 160.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.greenGradient,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFF429690,
                                          ).withOpacity(0.4),
                                          blurRadius: 30,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Icon(
                                            Icons.analytics_outlined,
                                            size: 80.sp,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        // Orbiting elements
                                        ...List.generate(3, (index) {
                                          return Positioned(
                                            top: 20.h + (index * 40.h),
                                            right: 10.w + (index * 20.w),
                                            child: Container(
                                              width: 12.w,
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.white
                                                    .withOpacity(0.8),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 30.h),

                                  // Tech badges
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildTechBadge(
                                        'AI-Powered',
                                        Icons.psychology,
                                      ),
                                      _buildTechBadge('Real-time', Icons.speed),
                                      _buildTechBadge('Secure', Icons.lock),
                                    ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for intro background
class Intro2BackgroundPainter extends CustomPainter {
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

Widget _buildTechBadge(String text, IconData icon) {
  return Column(
    children: [
      Icon(icon, color: AppColors.white, size: 24.sp),
      SizedBox(height: 4.h),
      Text(text, style: AppTextStyles.bodyRegular14.copyWith(color: AppColors.white, fontSize: 12.sp)),
    ],
  );
}
