import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:project/app/constant/theme/app_colors.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key, this.onTap, this.child, this.width, this.height, this.color});
  final Widget? child;
  final void Function()? onTap;
  final double? width;
  final double? height;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: color ?? AppColors.blue,
            borderRadius: BorderRadius.circular(5)),
        child: Center(child: child),
      ),
    );
  }
}
