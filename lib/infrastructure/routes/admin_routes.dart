import 'package:get/get.dart';

import '../../bindings/AddEnquiryBinding.dart';
import '../../bindings/InventoryBinding.dart';
import '../../bindings/NotificationBinding.dart';
import '../../bindings/ProfileBinding.dart';
import '../../bindings/WelcomeBinding.dart';
import '../../bindings/billing_binding.dart';
import '../../bindings/home_binding.dart';
import '../../bindings/login_binding.dart';
import '../../bindings/sign_up_binding.dart';

import '../../bindings/view_bills_binding.dart';
import '../../bindings/viewenquirybinding.dart';
import '../../screens/AddEnquiryScreen.dart';
import '../../screens/BillingScreen.dart';
import '../../screens/InventoryScreen.dart';
import '../../screens/NotificationScreen.dart';
import '../../screens/ProfileScreen.dart';
import '../../screens/WelcomeScreen.dart';
import '../../screens/admin_splash_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/sign_up_screen.dart';
import '../../screens/view_bills_screen.dart';
import '../../screens/viewenquiryscreen.dart';

class AdminRoutes {
  // ==================
  // Route Names
  // ==================
  static const ADMIN_SPLASH = '/admin/splash';
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const HOME = '/home';
  static const BILLING = '/billing';
  static const NOTIFICATIONS = '/notifications';
  static const addenquiry = '/addenquiry';
  static const inventory = '/inventory';
  static const viewbill = '/viewbill';
  static const viewenquiry = '/viewenquiry';
  static const profilescreen = '/profilescreen';




  // ==================
  // Route Definitions
  // ==================
  static final List<GetPage> routes = [
    // ---------- SPLASH ----------
    GetPage(
      name: ADMIN_SPLASH,
      page: () => AdminSplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 400),
    ),

    // ---------- WELCOME ----------
    GetPage(
      name: WELCOME,
      page: () => WelcomeScreen(),
      binding: WelcomeBinding(),
    ),

    // ---------- LOGIN ----------
    GetPage(
      name: LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),

    // ---------- SIGN UP ----------
    GetPage(
      name: SIGNUP,
      page: () => SignUpScreen(),
      binding: SignUpBinding(),
    ),

    // ---------- HOME ----------
    GetPage(
      name: HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),

    // ---------- BILLING ----------
    GetPage(
      name: BILLING,
      page: () => BillingScreen(),
      binding: BillingBinding(),
    ),

    // ---------- NOTIFICATIONS ----------
    GetPage(
      name: NOTIFICATIONS,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
    ),

    GetPage(
      name: addenquiry,
      page: () => AddEnquiryScreen(),
      binding: AddEnquiryBinding(),
    ),

    GetPage(
      name: inventory,
      page: () => InventoryScreen(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: viewbill,
      page: () => ViewBillsScreen(),
      binding: ViewBillsBinding(),
    ),
    GetPage(
      name: viewenquiry,
      page: () => ViewEnquiryScreen(),
      binding: ViewEnquiryBinding(),
    ),
    GetPage(
      name: profilescreen,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
