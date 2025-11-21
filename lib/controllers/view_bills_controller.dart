import 'package:get/get.dart';

class ViewBillsController extends GetxController {
  // Observable list of bills
  var bills = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBills();
  }

  // Fetching example data for the bills list (This is optional if data is not static)
  void fetchBills() async {
    // Simulating a delay as if fetching data from an API or database
    await Future.delayed(Duration(seconds: 2));

    // Sample bills data (Replace with actual API call or database query)
    bills.value = [

    ];
  }

  // Logic for viewing a specific bill (Navigate to detail screen)
  void viewBillDetail(int billId) {
    // Navigate to Bill Detail screen
    Get.toNamed('/billDetail', arguments: billId);
  }

  // Logic for deleting a bill
  void deleteBill(int billId) async {
    try {
      // Simulate deleting the bill from the list
      bills.removeWhere((bill) => bill['id'] == billId);
    } catch (e) {
      print("Error deleting bill: $e");
    }
  }
}
