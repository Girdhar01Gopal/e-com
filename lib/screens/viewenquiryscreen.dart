import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:share_plus/share_plus.dart';
import '../controllers/viewenquirycontroller.dart';

class ViewEnquiryScreen extends GetView<ViewEnquiryController> {
  const ViewEnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "View Enquiries",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Obx(() {
        if (controller.enquiryList.isEmpty) {
          return const Center(
            child: Text(
              "No Enquiries Added",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: controller.enquiryList.length,
          itemBuilder: (context, index) {
            final enquiry = controller.enquiryList[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
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
                          _row("Name", enquiry["name"] ?? ""),
                          _row("Phone", enquiry["phone"] ?? ""),
                          _row("Email", enquiry["email"] ?? ""),
                          _row("Message", enquiry["message"] ?? ""),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.green),
                      onPressed: () async {
                        final pdf = await _generatePDF(enquiry);
                        _sharePDF(pdf);
                      },
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

  Widget _row(String title, String value) {
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
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Future<File> _generatePDF(Map<String, String> enquiry) async {
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
            pw.Text("Name: ${enquiry['name']}"),
            pw.Text("Phone: ${enquiry['phone']}"),
            pw.Text("Email: ${enquiry['email']}"),
            pw.Text("Message: ${enquiry['message']}"),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/enquiry_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _sharePDF(File file) async {
    await Share.shareXFiles([XFile(file.path)], text: "Enquiry Details");
  }
}
