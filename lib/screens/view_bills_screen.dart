import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/BillingController.dart';

class ViewBillsScreen extends StatelessWidget {
  final BillingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the screen background color to white
      appBar: AppBar(
        title: const Text(
          "View Bills",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent, // Make the background transparent for gradient
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400], // Blue gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(
            () {
          if (controller.bills.isEmpty) {
            return Center(
              child: Text("No bills available."),
            );
          }

          return ListView.builder(
            itemCount: controller.bills.length,
            itemBuilder: (context, index) {
              var bill = controller.bills[index];

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(bill['customerName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display price in INR (₹)
                      Text("Price: ₹${bill['price']}"),
                      Text("Product: ${bill['product']}"),
                      Text("Buy Date: ${bill['buyDate']}"),
                      Text("Status: ${bill['status']}"),  // Display the status
                    ],
                  ),
                  // Optional: You can add actions like a share button here
                ),
              );
            },
          );
        },
      ),
    );
  }
}
