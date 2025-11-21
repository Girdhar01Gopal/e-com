import 'package:get/get.dart';

class HomeController extends GetxController {
  // For future dashboard API or state
  var isLoading = false.obs;

  // Navigation handler
  void goToScreen(String route) {
    Get.toNamed(route);
  }
}
