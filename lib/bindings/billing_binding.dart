import 'package:get/get.dart';
import '../controllers/BillingController.dart';

class BillingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillingController>(() => BillingController());
  }
}
