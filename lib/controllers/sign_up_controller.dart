import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Logic for Sign-Up Button
  void onSignUpPressed() {
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      // Show an error if any field is empty
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    if (password != confirmPassword) {
      // Show an error if passwords do not match
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    // Proceed with the sign-up process (e.g., make an API call)
    // For now, let's assume sign-up is successful.

    // Navigate to the login screen after successful sign-up
    Get.toNamed('/login');  // Replace '/login' with the actual route to your login screen
  }
}
