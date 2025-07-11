import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/theme/app_colors.dart';
import '../../constant/theme/app_text_style.dart';
import '../intro_screens/onbarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    
    // Navigate after delay
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => Onboarding())
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: CirclePatternPainter(),
              ),
            ),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with glow effect
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 120.w,
                          height: 120.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.greenGradient,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF429690).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.security,
                              size: 60.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 30.h),
                  
                  // App name with fade animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      "CyberShield",
                      style: AppTextStyles.headerBold30.copyWith(
                        color: AppColors.white,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 10.h),
                  
                  // Subtitle with fade animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Cyber Threat Intelligence',
                      style: AppTextStyles.bodyRegular14.copyWith(
                        color: AppColors.tertiary,
                        fontSize: 16.sp,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 50.h),
                  
                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.tertiary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom branding
            Positioned(
              bottom: 50.h,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'Powered by Threat Intelligence',
                      style: AppTextStyles.bodyRegular14.copyWith(
                        color: AppColors.tertiary.withOpacity(0.8),
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: 50.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.greenGradient,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for background pattern
class CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    // Draw circles pattern
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 12; j++) {
        double x = (size.width / 7) * i;
        double y = (size.height / 11) * j;
        canvas.drawCircle(
          Offset(x, y),
          20 + (i * 2).toDouble(),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}