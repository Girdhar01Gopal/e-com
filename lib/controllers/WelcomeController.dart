import 'package:get/get.dart';

class WelcomeController extends GetxController {
  // Reactive variables to track the button colors
  var isLoginButtonBlue = false.obs;
  var isRegisterButtonBlue = false.obs;

  // Logic for changing login button color
  void onLoginPressed() {
    isLoginButtonBlue.value = !isLoginButtonBlue.value;
    isRegisterButtonBlue.value = false; // Reset register button color
  }

  // Logic for changing register button color
  void onRegisterPressed() {
    isRegisterButtonBlue.value = !isRegisterButtonBlue.value;
    isLoginButtonBlue.value = false; // Reset login button color
  }
}
