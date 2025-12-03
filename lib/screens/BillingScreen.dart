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
    controller.buyDate.text = DateFormat("dd/MM/yyyy").format(DateTime.now());

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Builder(
        builder: (context) {
          final tabCtrl = DefaultTabController.of(context)!;

          return Scaffold(
            backgroundColor: Colors.white,

            appBar: AppBar(
              title: Text(
                "Billing\n$formattedDate",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.blue,

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            tabCtrl.animateTo(0);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            child: const Text(
                              "Create Bill",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        width: 3,
                        height: 30,
                        color: Colors.black,
                      ),

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AdminRoutes.viewbill);

                            Future.delayed(
                              const Duration(milliseconds: 100),
                                  () => tabCtrl.animateTo(0),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            child: const Text(
                              "View Bills",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            body: _buildCreateBillForm(context),
          );
        },
      ),
    );
  }

  // ==========================================================
  // ===================  CREATE BILL FORM  ====================
  // ==========================================================
  Widget _buildCreateBillForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
          _input("Buy Date", controller.buyDate, isReadOnly: false),

          const Divider(),

          _productSelector(context),

          const SizedBox(height: 15),

          _input("Brand", controller.brand, isReadOnly: true),
          _input("Category", controller.category, isReadOnly: true),
          _input("₹Price", controller.price, isNumeric: true),
          _input("Quantity", controller.quantity, isNumeric: true),
          _input("₹Discount", controller.discount, isNumeric: true),


          Obx(() {
            if (controller.grandTotal.value == 0) {
              return const SizedBox();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                "Grand Total: ₹${controller.grandTotal.value.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          }),
          // ======================================================

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
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
                );
                return;
              }

              // ⭐ Calculate Total
              controller.calculateGrandTotal();

              Get.snackbar(
                "Success",
                "Bill Created Successfully",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );

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
    );
  }

  // ==========================================================
  // ==============  PRODUCT SEARCH DIALOG  ====================
  // ==========================================================
  Widget _productSelector(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedProduct.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Product"),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _showProductSearchDialog(context),
            child: InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Tap to select product",
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              child: Text(
                selected?.productName ?? "Select Product",
                style: TextStyle(
                  color: selected == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showProductSearchDialog(BuildContext context) {
    final allProducts = controller.products;
    if (allProducts.isEmpty) {
      Get.snackbar(
        "No Products",
        "Product list is empty.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    TextEditingController searchCtrl = TextEditingController();
    List<BillProductModel> filtered = List<BillProductModel>.from(allProducts);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                "Select Product",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search product...",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final query = value.toLowerCase();
                        setState(() {
                          filtered = allProducts
                              .where((p) =>
                          p.productName
                              .toLowerCase()
                              .contains(query) ||
                              p.brandName
                                  .toLowerCase()
                                  .contains(query) ||
                              p.categoryName
                                  .toLowerCase()
                                  .contains(query))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(child: Text("No products found"))
                          : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final p = filtered[index];
                          return ListTile(
                            title: Text(p.productName),
                            subtitle: Text(
                                "${p.brandName} • ${p.categoryName}"),
                            onTap: () {
                              controller.onProductSelected(p);
                              Navigator.of(ctx).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // ================== INPUT FIELD ===========================
  // ==========================================================
  Widget _input(
      String label,
      TextEditingController ctrl, {
        bool isEmail = false,
        bool isPhone = false,
        bool isNumeric = false,
        bool isReadOnly = false,
        Function(String)? onChanged,
      }) {
    String hint = label == "Buy Date" ? "DD/MM/YYYY" : "Enter $label";

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
