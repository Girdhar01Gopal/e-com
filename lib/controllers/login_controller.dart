import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Logic to handle login
  void onLoginPressed() {
    // Add your login logic here
    String email = emailController.text;
    String password = passwordController.text;

    // For now, just print email and password
    print("Email: $email, Password: $password");

    // You can navigate to another screen upon successful login
    // Get.to(HomeScreen());  // Example
  }
}
