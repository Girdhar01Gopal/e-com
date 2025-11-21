import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/viewenquiryscreen.dart';

class AddEnquiryController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  var isSubmitting = false.obs;
  final formKey = GlobalKey<FormState>();

  // Shared enquiry list
  static RxList<Map<String, String>> enquiries = <Map<String, String>>[].obs;

  Future<void> submitEnquiry() async {
    if (!formKey.currentState!.validate()) return;

    isSubmitting.value = true;
    await Future.delayed(const Duration(seconds: 1));

    enquiries.add({
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "message": messageController.text,
    });

    isSubmitting.value = false;

    Get.snackbar(
      "Success",
      "Enquiry added successfully!",
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );

    clearForm();

    // Navigate to View Enquiry Screen
    Get.to(() => ViewEnquiryScreen());
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
