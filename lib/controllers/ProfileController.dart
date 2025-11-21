import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final shopNameController = TextEditingController();

  final isEditing = false.obs; // Toggle edit mode
  final formKey = GlobalKey<FormState>();

  RxMap<String, dynamic> profileData = {
    "shopName": "",
    "name": "",
    "phone": "",
    "email": "",
    "address": "",
  }.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // ---------------------------
  // Load profile from storage
  // ---------------------------
  void loadProfile() {
    var data = storage.read("shopkeeper_profile");
    if (data != null) {
      profileData.value = Map<String, dynamic>.from(data);
      _fillControllers();
    }
  }

  // ---------------------------
  // Fill controllers with data
  // ---------------------------
  void _fillControllers() {
    shopNameController.text = profileData["shopName"];
    nameController.text = profileData["name"];
    phoneController.text = profileData["phone"];
    emailController.text = profileData["email"];
    addressController.text = profileData["address"];
  }

  // ---------------------------
  // Save / Update Profile
  // ---------------------------
  void updateProfile() {
    if (!formKey.currentState!.validate()) return;

    profileData.value = {
      "shopName": shopNameController.text,
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "address": addressController.text,
    };

    storage.write("shopkeeper_profile", profileData);

    isEditing.value = false;

    Get.snackbar(
      "Success",
      "Profile updated successfully",
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );
  }
}
