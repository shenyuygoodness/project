
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class OnboardingContainer extends StatelessWidget {
  const OnboardingContainer({super.key, this.topChild, this.bottomChild});

  final Widget? topChild;
  final Widget? bottomChild;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(0.0),
            margin: EdgeInsets.all(0),
            height: 400.h,
            width: 414.w,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            child: topChild,
          ),
          Container(
            height: 340.h,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: bottomChild,
            ),
          ),
        ],
      ),
    );
  }
}
