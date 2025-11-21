import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../infrastructure/app_drawer/admin_drawer.dart';
import '../infrastructure/routes/admin_routes.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AdminDrawer(),
      backgroundColor: Colors.white, // Set the background color to white

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 5,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.notes, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: const Text(
          'Monteage',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.white),
            onPressed: () => Get.toNamed(AdminRoutes.NOTIFICATIONS),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            SizedBox(height: 10.h),

            /// HEADER
            Text(
              "👋 Welcome to the future of inspiration !",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 25.h),

            /// CARD 1 — BILLING
            _leadCard(
              title: "BILLING",
              gradient: LinearGradient(
                colors: [Color(0xffF2F2F2), Color(0xffD9D9D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              indicatorColor: Colors.yellow,
              textColor: Colors.black,
              extraShadow: true,

              /// OPEN BILLING SCREEN
              onTap: () => controller.goToScreen(AdminRoutes.BILLING),
            ),

            SizedBox(height: 18.h),

            /// CARD 2 — ADD ENQUIRY
            _leadCard(
              title: "ADD ENQUIRY",
              gradient: LinearGradient(
                colors: [Colors.blue.shade500, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              indicatorColor: Colors.lightBlueAccent,
              textColor: Colors.white,

              /// OPEN ADD ENQUIRY SCREEN
              onTap: () => controller.goToScreen(AdminRoutes.addenquiry),
            ),

            SizedBox(height: 18.h),

            /// CARD 3 — INVENTORY
            _leadCard(
              title: "INVENTORY",
              gradient: LinearGradient(
                colors: [Colors.grey.shade900, Colors.grey.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              indicatorColor: Colors.lightGreen,
              textColor: Colors.white,

              /// OPEN INVENTORY SCREEN
              onTap: () => controller.goToScreen(AdminRoutes.inventory),
            ),
            // SizedBox(height: 18.h),
            //
            // /// CARD 2 — ADD ENQUIRY
            // _leadCard(
            //   title: "PROFILE",
            //   gradient: LinearGradient(
            //     colors: [Colors.green.shade500, Colors.green.shade900],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            //   indicatorColor: Colors.white,
            //   textColor: Colors.white,
            //
            //   /// OPEN ADD ENQUIRY SCREEN
            //   onTap: () => controller.goToScreen(AdminRoutes.profilescreen),
            // ),
          ],
        ),
      ),
    );
  }
  /// SIMPLE CURVED CARD
  Widget _leadCard({
    required String title,
    required LinearGradient gradient,
    required Color indicatorColor,
    required Color textColor,
    required Function() onTap,
    bool extraShadow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 18.w),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(extraShadow ? 0.35 : 0.18),
              offset: Offset(0, extraShadow ? 8 : 4),
              blurRadius: extraShadow ? 28 : 10,
            ),
          ],
        ),

        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),

            /// RIGHT DOT
            Container(
              height: 26.w,
              width: 26.w,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
