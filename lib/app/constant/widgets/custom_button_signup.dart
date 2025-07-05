import 'package:project/app/constant/theme/app_colors.dart';
import 'package:project/app/constant/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



// ignore: must_be_immutable
class CustomButtonSignUp extends StatelessWidget {
  final String text;
  // final IconButton iconButton;
  // final ImageProvider? icon ;
  final Image pic;
  final void Function()? onTap;
  final double? width;
  final double? height;
  const CustomButtonSignUp(
      {super.key,
        required this.text,
        required this.onTap,
        this.width,
        this.height, required this.pic,
        // required this.icon, required this.iconButton
        });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              // color: AppColors.white,
              border: Border.all(color: AppColors.secondary, width: 2.0.w),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // IconButton(onPressed: onTap, icon: iconButton),
                pic,
                SizedBox(width: 5.w,),
                Text(
                  text,
                  style: AppTextStyles.bodyLight14
                      .copyWith( color: AppColors.tertiary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
