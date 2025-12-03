import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/BillingController.dart';

class ViewBillsScreen extends StatelessWidget {
  final BillingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.fetchAllBills();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Obx(() {
          if (!controller.isSearchMode.value) {
            return const Text(
              "View Bills",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          }

          return TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: "Search Bill No, Name, Phone, Product...",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            onChanged: (value) => controller.searchQuery.value = value.trim(),
          );
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                controller.isSearchMode.value ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                if (controller.isSearchMode.value) {
                  controller.isSearchMode.value = false;
                  controller.searchQuery.value = "";
                  FocusScope.of(context).unfocus();
                } else {
                  controller.isSearchMode.value = true;
                }
              },
            );
          }),
        ],
      ),

      body: Obx(() {
        final billsToShow = controller.filteredList.reversed.toList();

        return RefreshIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
          onRefresh: () async {
            controller.searchQuery.value = "";
            await controller.fetchAllBills();
          },

          child: billsToShow.isEmpty
              ? const Center(child: Text("No bills available."))
              : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: billsToShow.length,
            itemBuilder: (context, index) {
              final bill = billsToShow[index];
              final customer = bill.customer;
              final items = bill.items;

              String formattedDate;
              try {
                formattedDate = DateFormat("dd/MM/yyyy")
                    .format(DateTime.parse(bill.createdAt));
              } catch (_) {
                formattedDate = bill.createdAt;
              }

              return Obx(() {
                bool isExpanded = controller.expandedIndex.value == index;

                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 7,
                  shadowColor: Colors.purple.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6D6027),
                          Color(0xFFD3CBB8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: isExpanded ? 6 : 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "BILL NO: ${bill.billNumber}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.expandedIndex.value =
                                      isExpanded ? -1 : index;
                                    },
                                    child: AnimatedRotation(
                                      turns: isExpanded ? 0.5 : 0,
                                      duration: const Duration(milliseconds: 250),
                                      child: const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 26,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              if (!isExpanded) ...[
                                const SizedBox(height: 1),
                                Text(
                                  "Customer: ${customer.name}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.greenAccent),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Date: $formattedDate",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70),
                                ),
                              ],
                            ],
                          ),
                        ),

                        /// PDF BUTTON
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.picture_as_pdf,
                                color: Colors.red, size: 28),
                            onPressed: () async {
                              await controller.shareSingleBillPDF(bill);
                            },
                          ),
                        ),

                        /// EXPANDABLE CONTENT
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                          child: isExpanded
                              ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  "Customer Details",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                _coloredBoldRow("Name",
                                    customer.name, Colors.green),
                                _clickableRow(
                                    title: "Phone",
                                    value: customer.phone,
                                    isEmail: false),
                                _clickableRow(
                                    title: "Email",
                                    value: customer.email,
                                    isEmail: true),
                                _row("Address", customer.address),

                                const Divider(color: Colors.white70),

                                const Text(
                                  "Product Details",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                ...items.map((item) {
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      _row("Product", item.name),
                                      _row("Price",
                                          "${item.price}"),
                                      _row("Quantity",
                                          "${item.quantity}"),
                                      _row("Discount",
                                          "${item.discount}"),
                                      if (item.category.isNotEmpty)
                                        _row("Category",
                                            item.category),
                                      if (item.brand.isNotEmpty)
                                        _row("Brand", item.brand),
                                      const Divider(
                                          color: Colors.white30),
                                    ],
                                  );
                                }).toList(),

                                _row("Total", "${bill.total}"),
                                _row("Date", formattedDate),
                              ],
                            ),
                          )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }

  /// ROWS ------------------------

  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text("$title:",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white)),
          ),
          Expanded(
            child: Text(
              value ?? "",
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _coloredBoldRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text("$title:",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 16, color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _clickableRow({
    required String title,
    required String value,
    required bool isEmail,
  }) {
    return InkWell(
      onTap: () async {
        final Uri uri =
        isEmail ? Uri.parse("mailto:$value") : Uri.parse("tel:$value");
        if (await canLaunchUrl(uri)) {
          launchUrl(uri);
        } else {
          Get.snackbar("Error", "Cannot open link",
              backgroundColor: Colors.red);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Text("$title:",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white)),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
