import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/NotificationController.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),  // ← BACK ARROW WHITE
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade800,
                Colors.blue.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= SHOP INFO CARD =================
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade800,
                    Colors.blue.shade400,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.shopName.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    "GST: ${controller.gstNumber.value}",
                    style: TextStyle(
                      color: Colors.yellow[300],
                      fontSize: 16.sp,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    "Mobile: ${controller.mobileNumber.value}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    "Today's Bills: ${controller.todayBillsCount.value}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),

                  Text(
                    "Today's Amount: ₹${controller.todayAmount.value}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              )),
            ),

            SizedBox(height: 20.h),

            Text(
              "Recent Notifications",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10.h),

            // ================= NOTIFICATION LIST =================
            Expanded(
              child: Obx(() {
                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Text(
                      "No notifications found.",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notif = controller.notifications[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(Icons.notifications, color: Colors.blue.shade800),
                        title: Text(notif['title']),
                        subtitle: Text(notif['message']),
                        trailing: Text(
                          notif['time'],
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
