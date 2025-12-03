class InventoryItem {
  String id;
  String name;
  int quantity;
  double price;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  // Convert InventoryItem to JSON for saving in a database or network
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  // Convert JSON back to InventoryItem
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}
