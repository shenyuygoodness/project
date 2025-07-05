
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

PageController _controller = PageController();
bool onLastPage = false;

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 1);
            });
          },
          controller: _controller,
          children: const [
            Onboarding1(),
            Onboarding2(),
          ],
        ),
        Container(
          alignment: const Alignment(0, 0.91),
          child: SmoothPageIndicator(
            controller: _controller,
            count: 2,
            effect: WormEffect(
                dotHeight: 10.h,
                dotWidth: 40.w,
                dotColor: AppColors.white,
                activeDotColor: AppColors.primary),
          ),
        ),
        onLastPage
            ? Container(
                alignment: const Alignment(0, 0.815),
                child: CommonButton(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: Text(
                    'Get Started',
                    style: AppTextStyles.bodyRegular14.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              )
            : Container(
                alignment: const Alignment(0, 0.815),
                child: CommonButton(
                  onTap: () {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Easing.linear);
                  },
                  child: Text(
                    'Next',
                    style: AppTextStyles.bodyRegular14.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
        onLastPage
            ? Container()
            : Container(
                alignment: const Alignment(0, -0.8),
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, bottom: 33),
                  child: GestureDetector(
                    onTap: () {
                      _controller.animateToPage(4,
                          duration: Durations.long1,
                          curve: Easing.legacyDecelerate);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Skip',
                          style: AppTextStyles.smallBold12.copyWith(
                              color: AppColors.white, fontSize: 14.sp),
                        ),
                        // ImageIcon(
                        //   AssetImage(IconsAssets.iconFront),
                        //   color: AppColors.white,
                        //   size: 14.sp,
                        // )
                      ],
                    ),
                  ),
                ),
              ),
      ]),
    );
  }
}
