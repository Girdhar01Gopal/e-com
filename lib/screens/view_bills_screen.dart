import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/BillingController.dart';

class ViewBillsScreen extends StatelessWidget {
  final BillingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "View Bills",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Obx(() {
        if (controller.bills.isEmpty) {
          return const Center(
            child: Text("No bills available."),
          );
        }

        return ListView.builder(
          itemCount: controller.bills.length,
          itemBuilder: (context, index) {
            var bill = controller.bills[index];

            return Card(
              margin: const EdgeInsets.all(12),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // CUSTOMER NAME (Bold)
                    Text(
                      bill['customerName'] ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // CUSTOMER DETAILS
                    _row("Phone", bill['phone']),
                    _row("Email", bill['email']),
                    _row("Address", bill['address']),
                    _row("Buy Date", bill['buyDate']),

                    const Divider(height: 25),

                    // PRODUCT DETAILS
                    _row("Product", bill['product']),
                    _row("Brand", bill['brand']),
                    _row("Category", bill['category']),
                    _row("Price", "₹${bill['price']}"),
                    _row("Quantity", bill['quantity']),
                    _row("Discount", "₹${bill['discount']}"),
                    _row("Subtotal", "₹${bill['subtotal']}"),
                    _row("Total", "₹${bill['grandTotal']}"),

                    const Divider(height: 25),

                    // STATUS
                    Row(
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Text(
                            bill['status'] ?? "",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Reusable row widget
  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110,
              child: Text(
                "$title:",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15),
              )),
          Expanded(
            child: Text(
              value ?? "",
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
