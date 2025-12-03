import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/InventoryController.dart';
import 'add_item_screen.dart';
import 'update_item_screen.dart';

class InventoryScreen extends StatelessWidget {
  // Initialize the controller
  final InventoryController controller = Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventory',
          style: TextStyle(color: Colors.white),  // Set text color to white
        ),
        backgroundColor: Colors.blueAccent, // AppBar background color
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent], // Blue gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,  // Set back arrow color to white
          ),
          onPressed: () {
            Get.back(); // Go back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add,
              color: Colors.white,),
            onPressed: () {
              Get.to(() => AddItemScreen()); // Navigate to AddItemScreen
            },
          ),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.inventoryList.length,
          itemBuilder: (context, index) {
            var item = controller.inventoryList[index];
            // Determine stock status based on quantity
            String stockStatus = item.quantity > 0 ? 'In Stock' : 'Out of Stock';
            Color stockColor = item.quantity > 0 ? Colors.green : Colors.red;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              elevation: 8,  // Add shadow for a more professional look
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),  // Rounded corners for card
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                leading: CircleAvatar(
                  child: Text(
                    item.name[0], // Show the first letter of item name
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  radius: 30,  // Size of the circular avatar
                  backgroundColor: Colors.blueAccent,  // Background color of the avatar
                  foregroundColor: Colors.white,  // Text color inside the avatar
                ),
                title: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,  // Prevent text overflow in the title
                  maxLines: 1,  // Limit title to one line
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Slightly larger font for the item name
                    color: Colors.black87,  // Dark color for text to improve readability
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Quantity
                    Text(
                      'Qty: ${item.quantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.grey[700], // Slightly muted color for quantity
                      ),
                    ),
                    SizedBox(width: 15), // Space between quantity and stock status
                    // Stock status with color
                    Text(
                      stockStatus,
                      style: TextStyle(
                        color: stockColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,  // Ensure Column takes minimum space
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Display the price with Indian Rupees
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 5), // Small gap between price and edit button
                    // Edit Icon with fixed size to prevent overflow
                    Container(
                      width: 40,  // Fixed width for the icon button
                      height: 28, // Fixed height for the icon button
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent, // Background color of the icon button
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.red,  // White color for the edit icon
                        ),
                        onPressed: () {
                          Get.to(() => UpdateItemScreen(item: item)); // Navigate to UpdateItemScreen
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
