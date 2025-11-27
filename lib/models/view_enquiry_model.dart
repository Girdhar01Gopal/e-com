class ViewEnquiryModel {
  bool success;
  List<Data> data;

  // Constructor
  ViewEnquiryModel({required this.success, required this.data});

  // From JSON
  ViewEnquiryModel.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        data = (json['data'] as List<dynamic>?)
            ?.map((v) => Data.fromJson(v))
            .toList() ?? [];

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((v) => v.toJson()).toList(),
    };
  }
}

class Data {
  int id;
  String name;
  String mobile;
  String email;
  String message;
  String createdAt;
  String updatedAt;

  // Constructor
  Data({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        mobile = json['mobile'],
        email = json['email'],
        message = json['message'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'message': message,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}




