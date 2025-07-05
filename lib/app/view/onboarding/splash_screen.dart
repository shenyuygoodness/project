import 'dart:async';
import 'package:flutter/material.dart';

import '../../constant/theme/app_colors.dart';
import '../../constant/theme/app_text_style.dart';
import '../intro_screens/onbarding.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  void initState(){
    super.initState();
      Timer(Duration(seconds: 3), () { 
       Navigator.push(context, MaterialPageRoute(builder: (context)=>Onboarding()));
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient:LinearGradient(colors: [
              Color(0xFF0F1A24),
              Color(0xFF21364A),
            ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
          child: Center(
            child: Text('SECWare',style:AppTextStyles.headerBold30.copyWith(color: AppColors.black),),),
          ),
    );
  }
}