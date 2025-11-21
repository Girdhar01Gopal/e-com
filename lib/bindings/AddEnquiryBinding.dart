import 'package:get/get.dart';
import '../controllers/AddEnquiryController.dart';

class AddEnquiryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEnquiryController>(() => AddEnquiryController());
  }
}
