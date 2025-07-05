
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:project/app/constant/theme/app_colors.dart';
import 'package:project/app/constant/theme/app_text_style.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.textController,
    required this.hintText,
    this.isObscure = false,
    this.enabled = true,
    this.label,
  });

  // final textController = TextEditingController();

  final TextEditingController textController;
  final String hintText;
  final bool isObscure;
  final bool enabled;
  final String? label;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              label!,
              style:
                  AppTextStyles.bodyRegular14.copyWith(color: AppColors.white),
            ),
          ),
        ],
        SizedBox(
          child: TextFormField(
            controller: textController,
            obscureText: isObscure,
            enabled: enabled,
            style: AppTextStyles.bodyBold14.copyWith(color: AppColors.tertiary),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.secondary,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              hintText: hintText,
              hintStyle: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.tertiary,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                  borderRadius: BorderRadius.circular(10)),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondary),
                  borderRadius: BorderRadius.circular(10)),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }
}
