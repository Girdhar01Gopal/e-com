import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class InventoryController extends GetxController {
  final storage = GetStorage();  // Persistent storage

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  // Form controllers
  final nameController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadInventory();
  }

  // -------------------------
  // LOAD INVENTORY FROM LOCAL STORAGE
  // -------------------------
  void loadInventory() {
    List? storedData = storage.read("inventory_items");
    if (storedData != null) {
      items.value = List<Map<String, dynamic>>.from(storedData);
    }
  }

  // -------------------------
  // SAVE INVENTORY TO STORAGE
  // -------------------------
  void saveInventory() {
    storage.write("inventory_items", items);
  }

  // -------------------------
  // ADD ITEM
  // -------------------------
  void addInventoryItem() {
    if (!formKey.currentState!.validate()) return;

    items.add({
      "name": nameController.text,
      "qty": qtyController.text,
      "price": priceController.text,
    });

    saveInventory(); // persist

    clearForm();
    Get.back();

    Get.snackbar(
      "Success",
      "Item added successfully",
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );
  }

  // -------------------------
  // EDIT ITEM
  // -------------------------
  void editItem(int index) {
    nameController.text = items[index]["name"];
    qtyController.text = items[index]["qty"];
    priceController.text = items[index]["price"];
  }

  // -------------------------
  // UPDATE ITEM
  // -------------------------
  void updateItem(int index) {
    if (!formKey.currentState!.validate()) return;

    items[index] = {
      "name": nameController.text,
      "qty": qtyController.text,
      "price": priceController.text,
    };

    items.refresh();
    saveInventory();

    clearForm();
    Get.back();

    Get.snackbar(
      "Updated",
      "Item updated successfully",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void clearForm() {
    nameController.clear();
    qtyController.clear();
    priceController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    qtyController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
