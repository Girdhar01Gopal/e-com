import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/InventoryController.dart';

class InventoryScreen extends GetView<InventoryController> {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InventoryController());

    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: () => _openAddOrEditSheet(context),
        child: Icon(Icons.add, color: Colors.white),
      ),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
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
          "Inventory",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {
        if (controller.items.isEmpty) {
          return Center(
            child: Text(
              "No inventory items added yet",
              style: TextStyle(fontSize: 16.sp),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];

            return GestureDetector(
              onTap: () =>
                  _openAddOrEditSheet(context, isEdit: true, index: index),
              child: Container(
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${item['name']}\nQty: ${item['qty']} • ₹${item['price']}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Icons.edit, color: Colors.blue.shade700, size: 26),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // -------------------------
  // ADD / EDIT BOTTOM SHEET
  // -------------------------
  void _openAddOrEditSheet(BuildContext context,
      {bool isEdit = false, int? index}) {
    if (isEdit) controller.editItem(index!);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit ? "Edit Item" : "Add Item",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),

              _inputField(controller.nameController, "Item Name"),
              SizedBox(height: 12.h),

              _inputField(controller.qtyController, "Quantity",
                  keyboardType: TextInputType.number),
              SizedBox(height: 12.h),

              _inputField(controller.priceController, "Price",
                  keyboardType: TextInputType.number),
              SizedBox(height: 20.h),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 40.w),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  isEdit
                      ? controller.updateItem(index!)
                      : controller.addInventoryItem();
                },
                child: Text(
                  isEdit ? "Update Item" : "Add Item",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _inputField(TextEditingController ctrl, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
