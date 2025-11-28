import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/viewenquirycontroller.dart';
import '../models/view_enquiry_model.dart';

class ViewEnquiryScreen extends GetView<ViewEnquiryController> {
  const ViewEnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Obx(() {
          // If search mode is OFF -> show normal title
          if (!controller.isSearchMode.value) {
            return const Text(
              "View Enquiries",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }

          // If search mode is ON -> show search field
          return TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: "Search by name or phone...",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              controller.searchQuery.value = value.trim();
            },
          );
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Obx(() {
            final isSearch = controller.isSearchMode.value;
            return IconButton(
              icon: Icon(
                isSearch ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                if (isSearch) {
                  // Turn OFF search
                  controller.isSearchMode.value = false;
                  controller.searchQuery.value = "";
                  FocusScope.of(context).unfocus();
                } else {
                  // Turn ON search
                  controller.isSearchMode.value = true;
                }
              },
            );
          }),
        ],
      ),

      body: Obx(() {
        // Reverse list to show latest on top
        List<Data> list = controller.enquiryList.reversed.toList();

        // Apply search filter if any
        final query = controller.searchQuery.value.toLowerCase();
        if (query.isNotEmpty) {
          list = list.where((e) {
            final name = (e.name ?? "").toLowerCase();
            final mobile = (e.mobile ?? "").toLowerCase();
            return name.contains(query) || mobile.contains(query);
          }).toList();
        }

        if (list.isEmpty) {
          return const Center(
            child: Text(
              "No Enquiries Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final enquiry = list[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF212121),
                        Color(0xFF616161),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _row("Name", enquiry.name ?? "", Colors.green),
                              _row("Phone", enquiry.mobile ?? "", Colors.white),
                              _row("Email", enquiry.email ?? "", Colors.white),
                              _row("Message", enquiry.message ?? "", Colors.white),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            final pdf = await _generatePDF(enquiry);
                            _sharePDF(pdf);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _row(String title, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<File> _generatePDF(Data enquiry) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Enquiry Details",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Text("Name: ${enquiry.name ?? ''}"),
            pw.Text("Phone: ${enquiry.mobile ?? ''}"),
            pw.Text("Email: ${enquiry.email ?? ''}"),
            pw.Text("Message: ${enquiry.message ?? ''}"),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      "${dir.path}/enquiry_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _sharePDF(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Enquiry Details",
    );
  }

  Future<void> _onRefresh() async {
    await controller.fetchEnquiries();
  }
}
