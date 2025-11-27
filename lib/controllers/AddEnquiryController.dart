import 'dart:convert';
import 'package:ecom_billing_app/controllers/viewenquirycontroller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/viewenquiryscreen.dart';

class AddEnquiryController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  var isSubmitting = false.obs;
  final formKey = GlobalKey<FormState>();

  // Shared enquiry list (local storage for enquiries)
  static RxList<Map<String, String>> enquiries = <Map<String, String>>[].obs;

  // POST API URL
  final String apiUrl = "https://fashion.monteage.co.in/api/enquiries";

  Future<void> submitEnquiry() async {
    if (!formKey.currentState!.validate()) return;

    // Prepare the body to be sent to the API
    final Map<String, String> body = {
      "name": nameController.text,
      "mobile": phoneController.text,
      "email": emailController.text,
      "message": messageController.text,
    };

    // Set the submitting state to true
    isSubmitting.value = true;

    // Send the POST request to the API
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Successfully added enquiry
        Get.snackbar(
          "Success",
          "Enquiry added successfully!",
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );

        // Add to the local list
        enquiries.add({
          "name": nameController.text,
          "phone": phoneController.text,
          "email": emailController.text,
          "message": messageController.text,
        });

        // Initialize the ViewEnquiryController before navigating
        Get.put(ViewEnquiryController());  // Ensure the ViewEnquiryController is put before navigation

        // Navigate to View Enquiry Screen
        Get.to(() => ViewEnquiryScreen());
      } else {
        // API call failed
        Get.snackbar(
          "Error",
          "Failed to add enquiry, please try again.",
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any exceptions (network issues, etc.)
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again later.",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      // Reset submitting state
      isSubmitting.value = false;
    }

    // Clear the form after submission
    clearForm();
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    messageController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
