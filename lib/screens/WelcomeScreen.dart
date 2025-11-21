import 'package:ecom_billing_app/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/WelcomeController.dart';
import '../screens/login_screen.dart';  // Import your LoginScreen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing the controller using GetX
    final WelcomeController controller = Get.put(WelcomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 1.h), // Space between the text and the image

              // Centered Image
              Image.asset(
                'assets/images/welcome_image.png', // Replace with your image
                width: 600.w, // Adjust the size if needed
                height: 600.h,
              ),

              SizedBox(height: 50.h), // Space between the image and the buttons

              // Row for login and register buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the Login Screen
                      Get.to(() =>  LoginScreen());  // Use Get.to() for navigation
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white, // Set the text color to white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color blue
                      minimumSize: Size(140.w, 50.h), // Adjust size for responsiveness
                    ),
                  ),

                  // Register Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the Register Screen
                      Get.to(() =>  SignUpScreen());  // Use Get.to() for navigation
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white, // Set the text color to white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color blue
                      minimumSize: Size(140.w, 50.h), // Adjust size for responsiveness
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
