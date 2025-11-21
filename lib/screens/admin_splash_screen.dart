import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/admin_splash_controller.dart';
import '../utils/constants/image_constants.dart';  // Ensure this is still used if necessary
import '../utils/constants/color_constants.dart';

class AdminSplashScreen extends StatelessWidget {
  const AdminSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminSplashController());

    return Scaffold(
      backgroundColor: AppColor.White,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ensures the image is centered vertically and horizontally
              Image.asset(
                'assets/images/splash_for store.jpeg',  // Corrected image path
                height: 200.h,
              ),
              SizedBox(height: 20.h),  // Optional: Add space below the logo if needed
            ],
          ),
        ),
      ),
    );
  }
}
