import 'package:get/get.dart';
import '../controllers/AddEnquiryController.dart';

class ViewEnquiryController extends GetxController {
  // Use the same reactive list from AddEnquiryController
  RxList<Map<String, String>> enquiryList = AddEnquiryController.enquiries;

  @override
  void onInit() {
    super.onInit();
  }
}
