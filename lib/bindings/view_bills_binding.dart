import 'package:get/get.dart';
import '../controllers/view_bills_controller.dart';

class ViewBillsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewBillsController>(() => ViewBillsController());
  }
}
