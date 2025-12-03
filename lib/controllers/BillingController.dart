import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/bill_model.dart';
import '../models/view_bill_model.dart';

class BillingController extends GetxController {
  // CUSTOMER FIELDS
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final buyDate = TextEditingController();

  // PRODUCT FIELDS
  final price = TextEditingController();
  final quantity = TextEditingController();
  final discount = TextEditingController();
  final brand = TextEditingController();
  final category = TextEditingController();

  var selectedProduct = Rx<BillProductModel?>(null);
  var selectedSku = Rx<SkuModel?>(null);
  var selectedStatus = "Success".obs;

  // SEARCH
  var searchQuery = "".obs;
  RxBool isSearchMode = false.obs;

  // UI
  var expandedIndex = (-1).obs;

  // LISTS
  RxList<BillProductModel> products = <BillProductModel>[].obs;
  RxList<Data> allBills = <Data>[].obs;
  RxList<Data> filteredBills = <Data>[].obs;

  // ⭐ NEW — GRAND TOTAL
  var grandTotal = 0.0.obs;

  // CAPITALIZE
  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // ⭐ NEW — GRAND TOTAL CALCULATION
  void calculateGrandTotal() {
    double p = double.tryParse(price.text) ?? 0;
    int q = int.tryParse(quantity.text) ?? 1;
    double d = double.tryParse(discount.text) ?? 0;

    grandTotal.value = (p * q) - (d * q);
  }

  // SEARCH LOGIC
  List<Data> get filteredList {
    if (searchQuery.value.isEmpty) return allBills;

    final q = searchQuery.value.toLowerCase();

    return allBills.where((bill) {
      final name = bill.customer.name.toLowerCase();
      final phone = bill.customer.phone.toLowerCase();
      final billNo = bill.billNumber.toLowerCase();
      final productMatch =
      bill.items.any((p) => p.name.toLowerCase().contains(q));

      return billNo.contains(q) ||
          name.contains(q) ||
          phone.contains(q) ||
          productMatch;
    }).toList();
  }

  void searchBills(String keyword) {
    searchQuery.value = keyword;
  }

  // API URLS
  final String apiProductList =
      "https://fashion.monteage.co.in/api/product_details";
  final String apiPostBill =
      "https://fashion.monteage.co.in/api/offline-bills";
  final String apiViewBill =
      "https://fashion.monteage.co.in/api/view-offline-bill";

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // FETCH PRODUCTS
  Future<void> fetchProducts() async {
    try {
      final res = await http.get(Uri.parse(apiProductList));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        products.value = billProductModelFromJson(data);
      } else {
        Get.snackbar("Error", "Failed to load products",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "API Error: $e", backgroundColor: Colors.red);
    }
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

  // LOCAL BILL
  void saveLocalBill() {}

  // CREATE BILL API
  Future<void> createBillAPI() async {
    final Map<String, dynamic> body = {
      "items": [
        {
          "sku_id": selectedSku.value!.id,
          "quantity": int.tryParse(quantity.text) ?? 1,
          "price": double.tryParse(price.text) ?? 0,
          "discount": double.tryParse(discount.text) ?? 0,
          "name": selectedProduct.value?.productName ?? "",
          "category": category.text,
          "brand": brand.text
        }
      ],
      "customer": {
        "name": name.text,
        "phone": phone.text,
        "email": email.text,
        "address": address.text
      }
    };

    try {
      final response = await http.post(
        Uri.parse(apiPostBill),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Bill Created Successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
        );
      } else {
        Get.snackbar("Error", response.body, backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e", backgroundColor: Colors.red);
    }
  }

  // FETCH ALL BILLS
  Future<void> fetchAllBills() async {
    try {
      final res = await http.get(Uri.parse(apiViewBill));

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        final model = ViewBillModel.fromJson(jsonData);
        allBills.value = model.data;
      } else {
        Get.snackbar("Error", "Failed to fetch bills",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e", backgroundColor: Colors.red);
    }
  }

  // PDF GENERATION (unchanged)
  Future<void> shareSingleBillPDF(Data bill) async {
    final pdf = pw.Document();

    String formattedPDFDate = "";
    try {
      formattedPDFDate =
          DateFormat("dd/MM/yyyy").format(DateTime.parse(bill.createdAt));
    } catch (e) {
      formattedPDFDate = bill.createdAt;
    }

    double grandTotal = 0;

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
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

            pw.Text("Bill No: ${bill.billNumber}",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text("Date: $formattedPDFDate"),
            pw.Text("Status: Success",
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xff28a745))),
            pw.SizedBox(height: 20),
            pw.Divider(),

            pw.Text("Customer Info:",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Name: ${bill.customer.name}"),
            pw.Text("Phone: ${bill.customer.phone}"),
            pw.Text("Email: ${bill.customer.email}"),
            pw.Text("Address: ${bill.customer.address}"),
            pw.SizedBox(height: 20),
            pw.Divider(),

            pw.Text("Product Info:",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            ...bill.items.map((item) {
              double price = double.tryParse(item.price.toString()) ?? 0;
              int qty = item.quantity;
              double discount =
                  double.tryParse(item.discount.toString()) ?? 0;

              double totalDiscount = discount * qty;
              double subtotal = (price * qty) - totalDiscount;

              grandTotal += subtotal;

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Product: ${item.name}"),
                  pw.Text("Price: $price"),
                  pw.Text("Quantity: $qty"),
                  pw.Text("Discount: $discount (per unit)"),
                  if (item.category.isNotEmpty)
                    pw.Text("Category: ${item.category}"),
                  if (item.brand.isNotEmpty)
                    pw.Text("Brand: ${item.brand}"),
                  pw.SizedBox(height: 15),
                  pw.Text("Subtotal: $subtotal",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 14)),
                  pw.Divider(),
                ],
              );
            }).toList(),

            pw.SizedBox(height: 10),
            pw.Text("Grand Total: $grandTotal",
                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text("Contact: 9027622569"),
                  pw.Text("Email: monteage@gmail.com"),
                  pw.Text("Website: www.monteage.com"),
                  pw.SizedBox(height: 10),
                  pw.Text("Thank you for shopping with us!"),
                ],
              ),
            )
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        "${dir.path}/bill_${DateTime.now().millisecondsSinceEpoch}.pdf");

    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)],
        text: "Your Bill Receipt");
  }
}
