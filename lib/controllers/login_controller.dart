import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../screens/home_screen.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final box = GetStorage();

  final String loginApi =
      "https://montgymapi.eduagentapp.com/api/MonteageGymApp/Logins";

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Email & Password can't be empty",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(loginApi),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          json["statuscode"] == 200 &&
          json["message"] == "Login succesfully") {
        Get.snackbar(
          "Success",
          "Login Successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ⭐ IMPORTANT — SAVE LOGIN STATUS
        box.write("isLoggedIn", true);

        Future.delayed(const Duration(milliseconds: 800), () {
          Get.off(() => HomeScreen());
        });
      } else {
        Get.snackbar(
          "Login Failed",
          json["message"] ?? "Invalid credentials",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }
}
