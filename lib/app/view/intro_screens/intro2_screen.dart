
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/theme/app_colors.dart';
import '../../constant/theme/app_text_style.dart';
import '../../constant/utils/asset_strings.dart';
import '../../constant/widgets/onboarding_container.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OnboardingContainer(
      topChild: Image(
        image: AssetImage(ImagesAssets.onboarding2),
        fit: BoxFit.fill,
      ),
      bottomChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to SecWare',
            style: AppTextStyles.headerBold24
                .copyWith(color: AppColors.white, fontSize: 30.sp),
          ),
          SizedBox(
            height: 5,
          ),
          Text('Be informed, Learn and Stay Up to date, ',
              textAlign: TextAlign.center,
              style: AppTextStyles.headerMedium20.copyWith(
                color: AppColors.tertiary,
              )),
          SizedBox(
            height: 80.h,
          ),
        ],
      ),
    ));
  }
}
