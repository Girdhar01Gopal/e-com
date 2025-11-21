import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import '../controllers/BillingController.dart';
import '../infrastructure/routes/admin_routes.dart';  // Import the controller

class BillingScreen extends StatelessWidget {
  final BillingController controller = Get.put(BillingController());  // Make sure the controller is instantiated

  @override
  Widget build(BuildContext context) {
    // Get the current date and format it to dd-MM-yyyy
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: "Create Bill\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            children: <TextSpan>[
              // Display the formatted current date in the app bar
              TextSpan(
                text: formattedDate, // Show current date as dd-MM-yyyy
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blue, // Gradient background
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400], // Gradient effect
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () => Get.back(),
        ),
        actions: [
          // Three-dot menu icon button
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: Colors.white), // Three-dot icon
            onSelected: (value) {
              // Handle navigation when the menu item is selected
              if (value == 1) {
                Get.toNamed(AdminRoutes.viewbill);  // Correct navigation route
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Text("View Bill List"),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Customer Info Fields
            _input("Customer Name", controller.name, isMandatory: true),
            _input("Phone (+91)", controller.phone, isMandatory: true, isPhone: true),
            _input("Email", controller.email, isEmail: true),
            _input("Address", controller.address),
            _input("Buy Date (dd/mm/yyyy)", controller.buyDate), // Normal keyboard

            // Spacer Line
            Divider(),

            // Product Info Dropdown
            DropdownButtonFormField<String>(
              value: controller.selectedProduct.value,
              onChanged: (String? newValue) {
                controller.selectedProduct.value = newValue!;
              },
              decoration: InputDecoration(
                labelText: 'Product',
                border: OutlineInputBorder(),
              ),
              items: controller.products.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            SizedBox(height: 10),

            // Product Info Fields
            _input("Price", controller.price, isMandatory: true, isNumeric: true),
            _input("Quantity", controller.quantity, isMandatory: true, isNumeric: true),
            _input("Discount", controller.discount, isNumeric: true), // Discount field

            // Status Dropdown Field
            DropdownButtonFormField<String>(
              value: controller.selectedStatus.value,
              onChanged: (String? newValue) {
                controller.selectedStatus.value = newValue!;
              },
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ['Process', 'Success', 'Pending']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Create Bill Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Set the primary color to transparent
                minimumSize: Size(double.infinity, 60), // Button size
                shadowColor: Colors.transparent, // Remove the shadow
              ),
              onPressed: () async {
                // Check if discount is not greater than price
                if (double.tryParse(controller.discount.text) != null &&
                    double.tryParse(controller.price.text)! < double.tryParse(controller.discount.text)!) {
                  Get.snackbar("Error", "Discount cannot be more than the price",
                      backgroundColor: Colors.red, colorText: Colors.white);
                  return;
                }

                // Save the bill
                controller.createBill();

                // Generate PDF and share
                final pdf = await controller.generatePDF();
                controller.sharePDF(pdf);
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade400], // Blue gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                ),
                padding: EdgeInsets.symmetric(vertical: 15), // Padding for button content
                child: Text(
                  "       Create Bill       ",
                  style: TextStyle(
                    color: Colors.white, // White text color
                    fontWeight: FontWeight.bold, // Bold text
                    fontSize: 18, // Optional: Font size
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generic TextField with validation
  Widget _input(String label, TextEditingController c, {bool isMandatory = false, bool isEmail = false, bool isPhone = false, bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: c,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: isEmail ? "Enter a valid email" : "Enter $label",
          ),
          keyboardType: isPhone
              ? TextInputType.phone
              : isEmail
              ? TextInputType.emailAddress
              : isNumeric
              ? TextInputType.number
              : TextInputType.text, // Normal keyboard for Date
          inputFormatters: isPhone
              ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)] // Limit phone number to 10 digits
              : isNumeric
              ? [FilteringTextInputFormatter.digitsOnly] // Only digits
              : [],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
