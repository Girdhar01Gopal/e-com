import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/sign_up_controller.dart';  // Import the controller

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing the controller using GetX
    final SignUpController controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              SizedBox(height: 20.h),

              // Subheading
              Text(
                "Create an account to streamline your micro-business operations and record keeping",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: 50.h),

              // Email Address Field
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  hintText: "Enter Email",
                  labelText: "Email Address",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 20.h),

              // Password Field
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                ),
              ),

              SizedBox(height: 20.h),

              // Confirm Password Field
              TextField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                ),
              ),

              SizedBox(height: 20.h),

              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  controller.onSignUpPressed();
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  minimumSize: Size(340.w, 50.h), // Button size
                ),
              ),

              SizedBox(height: 20.h),

              // Already have an account? Log in Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the Login screen
                      Get.toNamed('/login');
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
