import 'package:get/get.dart';
import '../controllers/sign_up_controller.dart';  // Import the SignUpController

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    // Register the SignUpController to be lazily loaded when needed
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
