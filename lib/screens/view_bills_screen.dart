import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/BillingController.dart';

class ViewBillsScreen extends StatelessWidget {
  final BillingController controller = Get.find();
  final RxMap<int, bool> expanded = <int, bool>{}.obs;

  @override
  Widget build(BuildContext context) {
    controller.fetchAllBills();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "View Bills",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _openSearchDialog(context),
          )
        ],
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
        final billsToShow = controller.filteredBills.isNotEmpty ||
            controller.searchQuery.value.isNotEmpty
            ? controller.filteredBills
            : controller.allBills;

        return RefreshIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
          onRefresh: () async {
            controller.searchBills("");
            await controller.fetchAllBills();
          },

          child: billsToShow.isEmpty
              ? const Center(child: Text("No bills available."))
              : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: billsToShow.length,
            itemBuilder: (context, index) {
              var bill = billsToShow[billsToShow.length - 1 - index];
              var customer = bill.customer;
              var items = bill.items;

              String formattedDate = "";
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
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF212121),
                          Color(0xFF616161),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ---------------- HEADER ---------------- ///
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: isExpanded ? 6 : 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "BILL NO: ${bill.billNumber}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 250),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.expandedIndex.value =
                                        isExpanded ? -1 : index;
                                      },
                                      child: const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 26,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /// COLLAPSED PREVIEW (VERY TIGHT)
                              if (!isExpanded) ...[
                                const SizedBox(height: 1),
                                Text(
                                  "Customer: ${customer.name}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Date: $formattedDate",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],

                              /// WHEN EXPANDED → VERY SMALL GAP BEFORE DETAILS
                              if (isExpanded) const SizedBox(height: 4),
                            ],
                          ),
                        ),


                        /// PDF BUTTON - ALWAYS CLICKABLE
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 28,
                            ),
                            onPressed: () async {
                              await controller.shareSingleBillPDF(bill);
                            },
                          ),
                        ),

                        /// ---------------- EXPANDABLE SECTION ---------------- ///
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

                                _coloredBoldRow(
                                    "Name",
                                    customer.name,
                                    Colors.green),
                                _clickableRow(
                                    title: "Phone",
                                    value: customer.phone,
                                    isEmail: false),
                                _clickableRow(
                                    title: "Email",
                                    value: customer.email,
                                    isEmail: true),
                                _row("Address", customer.address),

                                const Divider(
                                    color: Colors.white70),

                                const Text(
                                  "Product Details",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight.bold,
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
                                          item.quantity.toString()),
                                      _row("Discount",
                                          item.discount.toString()),
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

  void _openSearchDialog(BuildContext context) {
    final searchCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Search Bill"),
        content: TextField(
          controller: searchCtrl,
          decoration: const InputDecoration(
            hintText: "Search by Bill No, Name, Phone",
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("Search"),
            onPressed: () {
              controller.searchBills(searchCtrl.text.trim());
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
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
            child: Text(
              "$title:",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w900,
              ),
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
              child: Text(
                "$title:",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              ),
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
