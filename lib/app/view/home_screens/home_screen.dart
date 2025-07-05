import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/app/constant/theme/app_colors.dart';
import 'package:project/app/constant/theme/app_text_style.dart';
import 'package:project/app/constant/widgets/button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "CyberShield",
          style: AppTextStyles.bodyBold16.copyWith(color: AppColors.white),
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: ListTile(
              title: Text(
                "Introduction to malware basics",
                style: AppTextStyles.bodyBold16.copyWith(
                  color: AppColors.white,
                ),
              ),
              subtitle: Column(
                children: [
                  Text(
                    // Get definitions of various malware-related terms that will help you understand the malware threats. Familiarize yourself with Indicators of Compromise and types 
                    "Get started with CyberShield. Know more about malwares basics, their categories, Some malware families and their variants. ",
                    style: AppTextStyles.bodyBold16.copyWith(
                      color: AppColors.tertiary,
                    ),
                  ),
                  CommonButton(
                    child: Text("Get Started"),
                    width: 200.w,
                    height: 48.h,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: ListTile(
              title: Text(
                "Be at your A-Game with lastest malware",
                style: AppTextStyles.bodyBold16.copyWith(
                  color: AppColors.white,
                ),
              ),
              subtitle: Column(
                children: [
                  Text(
                    //  Get definitions of various malware-related terms that will help you understand the malware threats. Familiarize yourself with Indicators of Compromise and types
                    "Get started with CyberShield. Know more about malwares basics, their categories, Some malware families and their variants.",
                    style: AppTextStyles.bodyBold16.copyWith(
                      color: AppColors.tertiary,
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CommonButton(
                      child: Text("Get Started",style: AppTextStyles.bodyBold16.copyWith(
                        color: AppColors.secondary),),
                      width: 100.w,
                      height: 30.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
