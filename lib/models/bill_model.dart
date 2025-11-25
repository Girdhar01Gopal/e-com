// bill_model.dart

class SkuModel {
  final String id;
  final String price;
  final String sellPrice;
  final String size;

  SkuModel({
    required this.id,
    required this.price,
    required this.sellPrice,
    required this.size,
  });

  factory SkuModel.fromJson(Map<String, dynamic> json) {
    return SkuModel(
      id: json["id"] ?? "",
      price: json["price"] ?? "0",
      sellPrice: json["sell_price"] ?? "0",
      size: json["size"] ?? "N/A",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "price": price,
      "sell_price": sellPrice,
      "size": size,
    };
  }
}

class BillProductModel {
  final String productName;
  final String brandName;
  final String categoryName;
  final List<SkuModel> skus;

  BillProductModel({
    required this.productName,
    required this.brandName,
    required this.categoryName,
    required this.skus,
  });

  factory BillProductModel.fromJson(Map<String, dynamic> json) {
    return BillProductModel(
      productName: json["product_name"] ?? "",
      brandName: json["brand_name"] ?? "",
      categoryName: json["category_name"] ?? "",
      skus: (json["skus"] as List<dynamic>? ?? [])
          .map((e) => SkuModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_name": productName,
      "brand_name": brandName,
      "category_name": categoryName,
      "skus": skus.map((e) => e.toJson()).toList(),
    };
  }
}

/// Parse full API response list
List<BillProductModel> billProductModelFromJson(List<dynamic> list) {
  return list.map((item) => BillProductModel.fromJson(item)).toList();
}
