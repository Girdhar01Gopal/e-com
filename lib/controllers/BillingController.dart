import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/bill_model.dart';

class BillingController extends GetxController {

  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final buyDate = TextEditingController();

  // Product Inputs
  final price = TextEditingController();
  final quantity = TextEditingController();
  final discount = TextEditingController();
  final brand = TextEditingController();
  final category = TextEditingController();

  // Rx Values
  var selectedProduct = Rx<BillProductModel?>(null);
  var selectedSku = Rx<SkuModel?>(null);
  var selectedStatus = "Process".obs;

  // Track expanded cards (View Bill Screen)
  var expandedCards = <int, bool>{}.obs;

  void toggleExpand(int id) {
    expandedCards[id] = !(expandedCards[id] ?? false);
  }

  // LIST OF PRODUCTS FROM API
  RxList<BillProductModel> products = <BillProductModel>[].obs;

  // API URL
  final String apiUrl = "https://fashion.monteage.co.in/api/product_details";

  // FETCH PRODUCTS
  Future<void> fetchProducts() async {
    try {
      final res = await http.get(Uri.parse(apiUrl));

      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        products.value = billProductModelFromJson(data);
      } else {
        Get.snackbar("Error", "Failed to load products");
      }
    } catch (e) {
      Get.snackbar("Error", "API Error: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // SELECT PRODUCT
  void onProductSelected(BillProductModel product) {
    selectedProduct.value = product;

    brand.text = product.brandName;
    category.text = product.categoryName;

    if (product.skus.isNotEmpty) {
      onSkuSelected(product.skus.first);
    }
  }

  // SELECT SKU
  void onSkuSelected(SkuModel sku) {
    selectedSku.value = sku;
    price.text = sku.sellPrice;
  }

  // CALCULATIONS
  double get subtotal {
    double p = double.tryParse(price.text) ?? 0;
    int q = int.tryParse(quantity.text) ?? 1;
    double d = double.tryParse(discount.text) ?? 0;
    return (p * q) - d;
  }

  double get grandTotal => subtotal;

  // SAVE BILL LOCALLY
  var bills = <Map<String, dynamic>>[].obs;

  void createBill() {
    bills.add({
      "customerName": name.text,
      "phone": phone.text,
      "email": email.text,
      "address": address.text,
      "buyDate": buyDate.text,
      "product": selectedProduct.value?.productName,
      "brand": brand.text,
      "category": category.text,
      "price": price.text,
      "quantity": quantity.text,
      "discount": discount.text,
      "subtotal": subtotal.toStringAsFixed(2),
      "grandTotal": grandTotal.toStringAsFixed(2),
      "sku": selectedSku.value?.id,
      "status": selectedStatus.value,
    });
  }

  // PDF GENERATION (UPDATED FULL LAYOUT)
  Future<File> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            // FULL HEADER BLOCK
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text("MONTEAGE SHOPPING",
                      style: pw.TextStyle(
                          fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  pw.Text("#OFFLINE BILL",
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                ],
              ),
            ),

            // CUSTOMER INFO
            pw.Text("Customer Info:",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Name: ${name.text}"),
            pw.Text("Phone: ${phone.text}"),
            pw.Text("Email: ${email.text}"),
            pw.Text("Address: ${address.text}"),
            pw.Text("Buyed On: ${buyDate.text}"),

            pw.SizedBox(height: 20),
            pw.Divider(),

            // PRODUCT DETAILS
            pw.Text("Product Details:",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Product Name: ${selectedProduct.value?.productName}"),
            pw.Text("Brand: ${brand.text}"),
            pw.Text("Category: ${category.text}"),
            pw.Text("Price: ${price.text}"),
            pw.Text("Quantity: ${quantity.text}"),
            pw.Text("Discount: ${discount.text}"),
            pw.Text("Subtotal: ${subtotal.toStringAsFixed(2)}"),

            pw.SizedBox(height: 20),
            pw.Divider(),

            // STATUS
            pw.Text("Status: ${selectedStatus.value}",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            // GRAND TOTAL (BOLD)
            pw.Text("Grand Total: ${grandTotal.toStringAsFixed(2)}",
                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            // FOOTER BLOCK
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text("For queries, contact: 9027622569"),
                  pw.Text("Monteage@gmail.com"),
                  pw.Text("Website: www.monteage.com"),
                  pw.SizedBox(height: 10),
                  pw.Text("Thank you for shopping with us!"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file =
    File("${dir.path}/bill_${DateTime.now().millisecondsSinceEpoch}.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // SHARE PDF
  Future<void> sharePDF(File file) async {
    await Share.shareXFiles([XFile(file.path)], text: "Your Bill Receipt");
  }
}
