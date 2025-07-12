import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/app/controller/services/auth_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constant/theme/app_colors.dart';
import '../../constant/theme/app_text_style.dart';
import '../../constant/widgets/button.dart';
import '../authentication/login.dart';
import 'intro1_screen.dart';
import 'intro2_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  PageController _controller = PageController();
  bool onLastPage = false;
  final AuthService _authService = AuthService();
  
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    try {
      await _authService.completeOnboarding();
      await _authService.markNotFirstTimeUser();
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    }
  }

  Future<void> _skipOnboarding() async {
    try {
      await _authService.completeOnboarding();
      await _authService.markNotFirstTimeUser();
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    }
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
        child: Stack(
          children: [
            // Background decoration
            Positioned.fill(
              child: CustomPaint(
                painter: OnboardingBackgroundPainter(),
              ),
            ),
            
            // Page view
            PageView(
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 1);
                });
                _buttonAnimationController.reset();
                _buttonAnimationController.forward();
              },
              controller: _controller,
              children: const [
                Onboarding1(),
                Onboarding2(),
              ],
            ),
            
            // Skip button (only on first page)
            if (!onLastPage)
              Positioned(
                top: 60.h,
                right: 24.w,
                child: AnimatedBuilder(
                  animation: _buttonAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _buttonAnimation.value,
                      child: GestureDetector(
                        onTap: _skipOnboarding,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Skip',
                                style: AppTextStyles.smallBold12.copyWith(
                                  color: AppColors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.white,
                                size: 12.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            
            // Page indicator
            Positioned(
              bottom: 140.h,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 2,
                  effect: WormEffect(
                    dotHeight: 12.h,
                    dotWidth: 12.w,
                    spacing: 16.w,
                    dotColor: AppColors.white.withOpacity(0.3),
                    activeDotColor: AppColors.white,
                    paintStyle: PaintingStyle.fill,
                  ),
                ),
              ),
            ),
            
            // Action button
            Positioned(
              bottom: 60.h,
              left: 24.w,
              right: 24.w,
              child: AnimatedBuilder(
                animation: _buttonAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _buttonAnimation.value,
                    child: Container(
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.greenGradient,
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF429690).withOpacity(0.4),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onLastPage
                              ? _completeOnboarding
                              : () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                          borderRadius: BorderRadius.circular(28.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    onLastPage ? 'Get Started' : 'Next',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.bodyBold16.copyWith(
                                      color: AppColors.white,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                if (!onLastPage) ...[
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.white,
                                    size: 16.sp,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for onboarding background
class OnboardingBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw geometric patterns
    for (int i = 0; i < 5; i++) {
      double radius = (size.width / 4) + (i * 20);
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2),
        radius,
        paint,
      );
    }
    
    // Draw connecting lines
    final linePaint = Paint()
      ..color = AppColors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;
    
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.4, size.height * 0.3),
      linePaint,
    );
    
    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.8),
      Offset(size.width, size.height * 0.4),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}