import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/BillingController.dart';
import '../models/bill_model.dart';
import '../infrastructure/routes/admin_routes.dart';

class BillingScreen extends StatelessWidget {
  final BillingController controller = Get.put(BillingController());

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    /// AUTO-SET BUY DATE ON SCREEN LOAD
    controller.buyDate.text =
        DateFormat("dd/MM/yyyy").format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Create Bill\n$formattedDate",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton(
            onSelected: (v) {
              if (v == 1) Get.toNamed(AdminRoutes.viewbill);
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 1, child: Text("View Bill List")),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // NAME with capitalization
            _input(
              "Customer Name",
              controller.name,
              onChanged: (value) {
                controller.name.text = controller.capitalizeFirst(value);
                controller.name.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.name.text.length),
                );
              },
            ),

            _input("Phone", controller.phone, isPhone: true),
            _input("Email", controller.email, isEmail: true),
            _input("Address", controller.address),

            ///  BUY DATE → auto-filled, editable
            _input("Buy Date", controller.buyDate, isReadOnly: false),

            const Divider(),

            // PRODUCT DROPDOWN
            Obx(() {
              return DropdownButtonFormField<BillProductModel>(
                isExpanded: true,
                value: controller.selectedProduct.value,
                decoration: const InputDecoration(
                  labelText: "Select Product",
                  border: OutlineInputBorder(),
                ),
                items: controller.products
                    .map(
                      (p) => DropdownMenuItem(
                    value: p,
                    child: Text(p.productName),
                  ),
                )
                    .toList(),
                onChanged: (p) {
                  if (p != null) controller.onProductSelected(p);
                },
              );
            }),

            const SizedBox(height: 10),

            // SKU DROPDOWN (intentionally commented as in your code)
            // Obx(() {
            //   if (controller.selectedProduct.value == null) {
            //     return const SizedBox();
            //   }
            //
            //   return DropdownButtonFormField<SkuModel>(
            //     value: controller.selectedSku.value,
            //     decoration: const InputDecoration(
            //       labelText: "Select SKU",
            //       border: OutlineInputBorder(),
            //     ),
            //     items: controller.selectedProduct.value!.skus
            //         .map(
            //           (s) => DropdownMenuItem(
            //         value: s,
            //         child: Text("${s.sellPrice} - ${s.size}"),
            //       ),
            //     )
            //         .toList(),
            //     onChanged: (s) {
            //       if (s != null) controller.onSkuSelected(s);
            //     },
            //   );
            // }),

            const SizedBox(height: 15),

            _input("Brand", controller.brand, isReadOnly: true),
            _input("Category", controller.category, isReadOnly: true),
            _input("₹Price", controller.price, isNumeric: true),
            _input("Quantity", controller.quantity, isNumeric: true),
            _input("₹Discount", controller.discount, isNumeric: true),

            const SizedBox(height: 20),

            // CREATE BILL BUTTON
            ElevatedButton(
              onPressed: () {
                // 🔴 REQUIRED FIELDS VALIDATION
                if (controller.name.text.trim().isEmpty ||
                    controller.phone.text.trim().isEmpty ||
                    controller.price.text.trim().isEmpty ||
                    controller.quantity.text.trim().isEmpty ||
                    controller.brand.text.trim().isEmpty ||
                    controller.category.text.trim().isEmpty) {
                  Get.snackbar(
                    "Missing Fields",
                    "Please fill all required fields before creating the bill.",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 10,
                  );
                  return;
                }

                // ✅ INSTANT SUCCESS SNACKBAR ON TAP
                Get.snackbar(
                  "Success",
                  "Bill Created Successfully",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(12),
                  borderRadius: 10,
                );

                // 🔄 FIRE-AND-FORGET API CALL (NO AWAIT, NO DELAY)
                controller.createBillAPI();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade400],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Create Bill",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // INPUT WIDGET
  Widget _input(
      String label,
      TextEditingController ctrl, {
        bool isEmail = false,
        bool isPhone = false,
        bool isNumeric = false,
        bool isReadOnly = false,
        Function(String)? onChanged,
      }) {
    String hint = "Enter $label";

    /// UPDATED: Buy Date hint
    if (label == "Buy Date") {
      hint = "DD/MM/YYYY";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: ctrl,
          readOnly: isReadOnly,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hint,
          ),
          keyboardType: isNumeric
              ? TextInputType.number
              : isPhone
              ? TextInputType.phone
              : isEmail
              ? TextInputType.emailAddress
              : TextInputType.text,
          inputFormatters: isNumeric
              ? [FilteringTextInputFormatter.digitsOnly]
              : isPhone
              ? [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ]
              : [],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
