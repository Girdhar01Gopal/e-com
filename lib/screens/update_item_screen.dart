import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/InventoryController.dart';
import '../models/inventory_model.dart';

class UpdateItemScreen extends StatefulWidget {
  final InventoryItem item;

  UpdateItemScreen({required this.item});

  @override
  _UpdateItemScreenState createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final InventoryController controller = Get.find();

  late String _name;
  late int _quantity;
  late double _price;

  @override
  void initState() {
    super.initState();
    _name = widget.item.name;
    _quantity = widget.item.quantity;
    _price = widget.item.price;
  }

  // Helper function to handle number format errors
  int _parseQuantity(String value) {
    return value.isNotEmpty ? int.tryParse(value) ?? 0 : 0;
  }

  double _parsePrice(String value) {
    return value.isNotEmpty ? double.tryParse(value) ?? 0.0 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Inventory Item'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Item Name Field
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        labelStyle: TextStyle(color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter item name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _name = value;
                      },
                    ),
                    SizedBox(height: 15),

                    // Quantity Field
                    TextFormField(
                      initialValue: _quantity.toString(),
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: TextStyle(color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        if (int.tryParse(value) == null || int.parse(value) < 0) {
                          return 'Please enter a valid positive number for quantity';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _quantity = _parseQuantity(value);
                      },
                    ),
                    SizedBox(height: 15),

                    // Price Field
                    TextFormField(
                      initialValue: _price.toString(),
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null || double.parse(value) < 0) {
                          return 'Please enter a valid positive price';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _price = _parsePrice(value);
                      },
                    ),
                    SizedBox(height: 20),

                    // Update Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Update the item in the controller
                          var updatedItem = InventoryItem(
                            id: widget.item.id,
                            name: _name,
                            quantity: _quantity,
                            price: _price,
                          );
                          controller.updateItem(updatedItem); // Update in controller

                          // Show success message and go back
                          Get.snackbar(
                            'Success',
                            'Item updated successfully!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          Get.back(); // Go back to inventory screen
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Set button color
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Update Item',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
