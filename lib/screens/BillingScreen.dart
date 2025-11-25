import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/BillingController.dart';
import '../infrastructure/routes/admin_routes.dart';
import '../models/bill_model.dart';

class BillingScreen extends StatelessWidget {
  final BillingController controller = Get.put(BillingController());

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create Bill\n$formattedDate",
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (v) {
              if (v == 1) {
                Get.toNamed(AdminRoutes.viewbill);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 1, child: Text("View Bill List")),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [

          _input("Customer Name", controller.name),
          _input("Phone (+91)", controller.phone, isPhone: true),
          _input("Email", controller.email, isEmail: true),
          _input("Address", controller.address),
          _input("Buy Date (dd/mm/yyyy)", controller.buyDate),

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
              items: controller.products.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      p.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (p) {
                if (p != null) controller.onProductSelected(p);
              },
            );
          }),

          const SizedBox(height: 10),

          // SKU DROPDOWN
          Obx(() {
            if (controller.selectedProduct.value == null ||
                controller.selectedProduct.value!.skus.isEmpty) {
              return const SizedBox();
            }
            return DropdownButtonFormField<SkuModel>(
              value: controller.selectedSku.value,
              decoration: const InputDecoration(
                  labelText: "SKU Detail", border: OutlineInputBorder()),
              items: controller.selectedProduct.value!.skus
                  .map((s) => DropdownMenuItem(
                  value: s, child: Text("${s.sellPrice} - ${s.size}")))
                  .toList(),
              onChanged: (s) => controller.onSkuSelected(s!),
            );
          }),

          const SizedBox(height: 10),

          _input("Brand", controller.brand, isReadOnly: true),
          _input("Category", controller.category, isReadOnly: true),
          _input("Price", controller.price, isNumeric: true),
          _input("Quantity", controller.quantity, isNumeric: true),
          _input("Discount", controller.discount, isNumeric: true),

          DropdownButtonFormField<String>(
            value: controller.selectedStatus.value,
            onChanged: (v) => controller.selectedStatus.value = v!,
            decoration: const InputDecoration(
                labelText: "Status", border: OutlineInputBorder()),
            items: ["Process", "Success", "Pending"]
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () async {
              controller.createBill();
              final pdf = await controller.generatePDF();
              controller.sharePDF(pdf);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade400]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Create Bill",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),

        ]),
      ),
    );
  }

  Widget _input(String label, TextEditingController c,
      {bool isEmail = false,
        bool isPhone = false,
        bool isNumeric = false,
        bool isReadOnly = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label),
      TextField(
        controller: c,
        readOnly: isReadOnly,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        keyboardType: isReadOnly
            ? TextInputType.none
            : isPhone
            ? TextInputType.phone
            : isEmail
            ? TextInputType.emailAddress
            : isNumeric
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: isNumeric
            ? [FilteringTextInputFormatter.digitsOnly]
            : isPhone
            ? [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10)
        ]
            : [],
      ),
      const SizedBox(height: 10),
    ]);
  }
}
