import 'dart:convert';

class ViewBillModel {
  final bool success;
  final String message;
  final List<Data> data;

  ViewBillModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ViewBillModel.fromJson(Map<String, dynamic> json) {
    return ViewBillModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((x) => Data.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((v) => v.toJson()).toList(),
  };
}

class Data {
  final int id;
  final String billNumber;
  final List<Items> items;
  final String total;
  final String createdAt;
  final String updatedAt;
  final Customer customer;

  Data({
    required this.id,
    required this.billNumber,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.customer,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    // Backend is storing JSON strings inside DB → decode again
    final itemsRaw = json['items'];
    final customerRaw = json['customer'];

    return Data(
      id: json['id'] ?? 0,
      billNumber: json['bill_number'] ?? '',
      items: itemsRaw is String
          ? List<Items>.from(
          (jsonDecode(itemsRaw) as List).map((x) => Items.fromJson(x)))
          : List<Items>.from(itemsRaw.map((x) => Items.fromJson(x))),
      total: json['total'].toString(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      customer: customerRaw is String
          ? Customer.fromJson(jsonDecode(customerRaw))
          : Customer.fromJson(customerRaw ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'bill_number': billNumber,
    'items': items.map((v) => v.toJson()).toList(),
    'total': total,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'customer': customer.toJson(),
  };
}

class Items {
  final String skuId;
  final int quantity;
  final num price;
  final num discount;
  final String name;
  final String category;
  final String brand;

  Items({
    required this.skuId,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.name,
    required this.category,
    required this.brand,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      skuId: json['sku_id'] ?? '',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,
      price: json['price'] is num
          ? json['price']
          : num.tryParse(json['price'].toString()) ?? 0,
      discount: json['discount'] is num
          ? json['discount']
          : num.tryParse(json['discount'].toString()) ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'sku_id': skuId,
    'quantity': quantity,
    'price': price,
    'discount': discount,
    'name': name,
    'category': category,
    'brand': brand,
  };
}

class Customer {
  final String name;
  final String phone;
  final String email;
  final String address;

  Customer({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'address': address,
  };
}
