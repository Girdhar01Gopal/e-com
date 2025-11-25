import 'package:get/get.dart';
import '../controllers/viewenquirycontroller.dart';

class ViewEnquiryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewEnquiryController>(() => ViewEnquiryController());
  }
}
