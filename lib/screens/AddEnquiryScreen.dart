import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/AddEnquiryController.dart';
import '../infrastructure/routes/admin_routes.dart';

class AddEnquiryScreen extends GetView<AddEnquiryController> {
  const AddEnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),

        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              Get.toNamed(AdminRoutes.viewenquiry);  // ← NAVIGATION
            },
          ),
        ],

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        title: const Text(
          "Add Enquiry",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(18.w),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              SizedBox(height: 15.h),

              _textField(
                controller.nameController,
                "Customer Name",
                Icons.person,
                validator: (value) =>
                value!.isEmpty ? "Enter customer name" : null,
              ),

              SizedBox(height: 15.h),

              _textField(
                controller.phoneController,
                "Phone Number",
                Icons.call,
                keyboard: TextInputType.phone,
                validator: (value) =>
                value!.length < 10 ? "Enter valid phone number" : null,
              ),

              SizedBox(height: 15.h),

              _textField(
                controller.emailController,
                "Email (Optional)",
                Icons.email,
                keyboard: TextInputType.emailAddress,
              ),

              SizedBox(height: 15.h),

              _textField(
                controller.messageController,
                "Enquiry Message",
                Icons.message,
                maxLines: 4,
                validator: (value) =>
                value!.isEmpty ? "Enter enquiry details" : null,
              ),

              SizedBox(height: 25.h),

              Obx(() {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitEnquiry,
                  child: controller.isSubmitting.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Submit Enquiry",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller,
      String label,
      IconData icon, {
        String? Function(String?)? validator,
        TextInputType keyboard = TextInputType.text,
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
