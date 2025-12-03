import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/inventory_model.dart';

class InventoryController extends GetxController {
  // Observable list of inventory items
  var inventoryList = <InventoryItem>[].obs;

  // Observable for loading state
  var isLoading = false.obs;

  // API base URL (replace with your API endpoint)
  final String apiUrl = 'https://yourapi.com/inventory';

  // Fetch inventory items from API (or populate with sample data)
  @override
  void onInit() {
    super.onInit();
    // Sample data (replace with actual API call)
    inventoryList.addAll([
      InventoryItem(id: '1', name: 'Laptop', quantity: 10, price: 1200.99),
      InventoryItem(id: '2', name: 'Phone', quantity: 50, price: 699.99),
      InventoryItem(id: '3', name: 'Headphones', quantity: 150, price: 99.99),
      InventoryItem(id: '4', name: 'Smartwatch', quantity: 200, price: 299.99),
      InventoryItem(id: '5', name: 'Charger', quantity: 100, price: 29.99),
      InventoryItem(id: '6', name: 'Keyboard', quantity: 75, price: 59.99),
      InventoryItem(id: '7', name: 'Mouse', quantity: 80, price: 19.99),
      InventoryItem(id: '8', name: 'Monitor', quantity: 30, price: 499.99),
      InventoryItem(id: '9', name: 'Speaker', quantity: 120, price: 129.99),
      InventoryItem(id: '10', name: 'Webcam', quantity: 60, price: 89.99),
    ]);
  }

  // Add item to inventory
  void addItem(InventoryItem item) {
    inventoryList.add(item); // Add item to the list
  }

  // Update an existing inventory item
  void updateItem(InventoryItem updatedItem) {
    int index = inventoryList.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      inventoryList[index] = updatedItem; // Update the item
    }
  }

  // Delete an inventory item
  void deleteItem(String id) {
    inventoryList.removeWhere((item) => item.id == id); // Remove item by ID
  }
}
