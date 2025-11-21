import 'package:get/get.dart';

class NotificationController extends GetxController {
  // SHOP INFO
  var shopName = "Monteage Shop".obs;
  var gstNumber = "07AABCU9603R1ZV".obs;
  var mobileNumber = "9876543210".obs;

  var todayBillsCount = 0.obs;
  var todayAmount = 0.0.obs;

  // NOTIFICATION LIST
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadShopInfo();
    loadNotifications();
  }

  void loadShopInfo() {
    // You can fetch from API or DB
    todayBillsCount.value = 14;
    todayAmount.value = 12590.50;
  }

  void loadNotifications() {
    notifications.value = [
      {
        "title": "New Bill Generated",
        "message": "Bill #1032 generated for ₹450",
        "time": "10:45 AM",
      },
      {
        "title": "Low Stock Alert",
        "message": "Item 'Pepsi 500ml' is running low.",
        "time": "9:20 AM",
      },
      {
        "title": "Payment Received",
        "message": "₹2,350 received via UPI.",
        "time": "Yesterday",
      },
    ];
  }
}
