import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BillingController extends GetxController {
  // Customer Info
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final buyDate = TextEditingController();

  // Product Info
  final product = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final discount = TextEditingController();

  // List of products for dropdown
  final List<String> products = [
    "Product 1",
    "Product 2",
    "Product 3",
    "Product 4",
    "Product 5",
    "Product 6",
    "Product 7",
    "Product 8",
    "Product 9",
    "Product 10"
  ];

  // Currently selected product
  var selectedProduct = RxString('Product 1');

  // Currently selected status
  var selectedStatus = RxString('Process');

  // List to store created bills
  var bills = <Map<String, dynamic>>[].obs;

  // Subtotal and Grand Total Calculations
  double get subtotal {
    double priceValue = double.tryParse(price.text) ?? 0;
    int quantityValue = int.tryParse(quantity.text) ?? 0;
    double discountValue = double.tryParse(discount.text) ?? 0;
    double total = priceValue * quantityValue;
    return total - discountValue;
  }

  double get grandTotal => subtotal;

  // Generate PDF
  Future<File> generatePDF() async {
    final pdf = pw.Document();

    final currentDate = DateTime.now();
    final formattedDate = "${currentDate.day}-${currentDate.month}-${currentDate.year} ${currentDate.hour}:${currentDate.minute}:${currentDate.second}";

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text("MONTEAGE SHOPPING",
                        style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Text("#ONLINE BILL",
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),

              // Customer Info Section
              pw.Text("Customer Info:",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Name: ${name.text}"),
              pw.Text("Phone: ${phone.text}"),
              pw.Text("Email: ${email.text}"),
              pw.Text("Address: ${address.text}"),
              pw.Text("Buyed On: ${buyDate.text}"),
              pw.SizedBox(height: 20),
              pw.Divider(),

              // Product Info Section
              pw.Text("Product Info:",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Product: ${selectedProduct.value}"),
              pw.Text("Price: ${price.text}"),
              pw.Text("Quantity: ${quantity.text}"),
              pw.Text("Discount: ${discount.text}"),
              pw.Text("Subtotal: ${subtotal.toStringAsFixed(2)}"),
              pw.SizedBox(height: 20),
              pw.Divider(),

              // Status Section
              pw.Text("Status: ${selectedStatus.value}",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              // Grand Total Section
              pw.Text("Grand Total: ${grandTotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              // Footer
              pw.Center(
                  child: pw.Column(children: [
                    pw.Text("For queries, contact: 9027622569"),
                    pw.Text("Monteage@gmail.com"),
                    pw.Text("Website: www.monteage.com"),
                    pw.SizedBox(height: 10),
                    pw.Text("Thank you for shopping with us!"),
                  ])),

              // Current Date and Time in the Corner
              pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.Text("Date: $formattedDate",
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.normal)),
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bill_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  // Share PDF
  Future<void> sharePDF(File file) async {
    await Share.shareXFiles([XFile(file.path)], text: "Your Bill Receipt");
  }

  // Save the created bill to the list
  void createBill() {
    var bill = {
      "customerName": name.text,
      "phone": phone.text,
      "email": email.text,
      "address": address.text,
      "buyDate": buyDate.text,
      "product": selectedProduct.value,
      "price": price.text,
      "quantity": quantity.text,
      "discount": discount.text,
      "status": selectedStatus.value,  // Add status field to the bill
      "subtotal": subtotal.toStringAsFixed(2),
      "grandTotal": grandTotal.toStringAsFixed(2),
    };

    bills.add(bill);
  }
}
