import 'package:get/get.dart';
import 'AddEnquiryController.dart';

class ViewEnquiryController extends GetxController {
  RxList<Map<String, String>> enquiryList = AddEnquiryController.enquiries;

  @override
  void onInit() {
    super.onInit();
  }
}
