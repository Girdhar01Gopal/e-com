import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/viewenquirycontroller.dart';
import '../models/view_enquiry_model.dart'; // Import the correct model

class ViewEnquiryScreen extends GetView<ViewEnquiryController> {
  const ViewEnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reverse the list to display the latest enquiries at the top
    var reversedList = controller.enquiryList.reversed.toList();

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

        return RefreshIndicator(
          onRefresh: _onRefresh, // This triggers the refresh action
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: reversedList.length,
            itemBuilder: (context, index) {
              final enquiry = reversedList[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF212121), // Darker shade for the gradient
                        Color(0xFF616161), // Lighter shade for the gradient
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
                              _row("Name", enquiry.name, Colors.green),
                              _row("Phone", enquiry.mobile, Colors.white),
                              _row("Email", enquiry.email, Colors.white),
                              _row("Message", enquiry.message, Colors.white),
                            ],
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.red), // Changed share icon color to red
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white, // Text color is white for clarity
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: textColor), // Custom text color
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
            pw.Text("Name: ${enquiry.name}"),
            pw.Text("Phone: ${enquiry.mobile}"),
            pw.Text("Email: ${enquiry.email}"),
            pw.Text("Message: ${enquiry.message}"),
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

  // Function to simulate fetching fresh data or reloading the list
  Future<void> _onRefresh() async {
    await controller.fetchEnquiries(); // This function should fetch the latest data from the API
  }
}
