import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/ProfileController.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Shopkeeper Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              controller.isEditing.value ? Icons.close : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              controller.isEditing.value = !controller.isEditing.value;
              if (!controller.isEditing.value) controller.loadProfile();
            },
          )),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Obx(() {
          return Form(
            key: controller.formKey,
            child: Column(
              children: [
                _profileTile("Shop Name", controller.shopNameController,
                    editable: controller.isEditing.value),
                SizedBox(height: 14.h),

                _profileTile("Owner Name", controller.nameController,
                    editable: controller.isEditing.value),
                SizedBox(height: 14.h),

                _profileTile("Phone Number", controller.phoneController,
                    editable: controller.isEditing.value,
                    keyboard: TextInputType.phone),
                SizedBox(height: 14.h),

                _profileTile("Email", controller.emailController,
                    editable: controller.isEditing.value,
                    keyboard: TextInputType.emailAddress),
                SizedBox(height: 14.h),

                _profileTile("Shop Address", controller.addressController,
                    editable: controller.isEditing.value, maxLines: 3),
                SizedBox(height: 30.h),

                controller.isEditing.value
                    ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(
                        vertical: 14.h, horizontal: 40.w),
                  ),
                  onPressed: controller.updateProfile,
                  child: Text(
                    "Save Profile",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
                    : const SizedBox(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _profileTile(
      String label,
      TextEditingController ctrl, {
        bool editable = false,
        TextInputType keyboard = TextInputType.text,
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 6.h),
        TextFormField(
          controller: ctrl,
          enabled: editable,
          maxLines: maxLines,
          keyboardType: keyboard,
          validator: (value) =>
          value!.isEmpty ? "Enter $label" : null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(14.w),
            filled: true,
            fillColor: editable ? Colors.white : Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
