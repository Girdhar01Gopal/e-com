import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' hide Data;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/view_enquiry_model.dart'; // Import the correct model file

class ViewEnquiryController extends GetxController {
  RxList<Data> enquiryList = <Data>[].obs; // List of Data objects from view_enquiry_model.dart
  final GetStorage storage = GetStorage();
  RxString searchQuery = "".obs;
  RxBool isSearchMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load enquiries from GetStorage first, then fetch from API if necessary
    loadEnquiriesFromStorage();
  }

  // Load enquiries from GetStorage
  void loadEnquiriesFromStorage() {
    final storedEnquiries = storage.read<List<dynamic>>('enquiries');
    if (storedEnquiries != null) {
      enquiryList.value = storedEnquiries.map((e) => Data.fromJson(e)).toList();
    } else {
      fetchEnquiries(); // Fetch from API if no data found in storage
    }
  }

  // Fetch enquiries from the API
  Future<void> fetchEnquiries() async {
    const String apiUrl = 'https://fashion.monteage.co.in/api/enquiries'; // API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final model = ViewEnquiryModel.fromJson(jsonData); // Using the correct model

        if (model.success) {
          enquiryList.value = model.data; // Update the enquiry list with the fetched data
          // Save the enquiries to GetStorage for persistence
          storage.write('enquiries', model.data.map((e) => e.toJson()).toList());
        } else {
          Get.snackbar('Error', 'Failed to fetch enquiries', backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar('Error', 'Failed to load data from the server', backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching data: $e', backgroundColor: Colors.red);
    }
  }
}
