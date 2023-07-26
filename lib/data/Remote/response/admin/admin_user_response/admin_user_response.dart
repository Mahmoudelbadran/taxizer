import 'dart:convert';
AdminUserResponse adminUserResponseFromJson(String str) => AdminUserResponse.fromJson(json.decode(str));
String adminUserResponseToJson(AdminUserResponse data) => json.encode(data.toJson());
class AdminUserResponse {
  AdminUserResponse({
      String? message,
    AdminUser? result,}){
    _message = message;
    _result = result;
}

  AdminUserResponse.fromJson(dynamic json) {
    _message = json['message'];
    _result = json['result'] != null ? AdminUser.fromJson(json['result']) : null;
  }
  String? _message;
  AdminUser? _result;

  String get message => _message??'';
  AdminUser get result => _result??AdminUser();

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_result != null) {
      map['result'] = _result?.toJson();
    }
    return map;
  }

}

AdminUser resultFromJson(String str) => AdminUser.fromJson(json.decode(str));
String resultToJson(AdminUser data) => json.encode(data.toJson());
class AdminUser {
  AdminUser({
      Location? location, 
      String? id, 
      String? userName, 
      String? email, 
      String? password, 
      String? phone, 
      String? addresses, 
      bool? active, 
      String? role, 
      List<dynamic>? history, 
      String? createdAt, 
      String? updatedAt, 
      num? v, 
      String? deviceToken,}){
    _location = location;
    _id = id;
    _userName = userName;
    _email = email;
    _password = password;
    _phone = phone;
    _addresses = addresses;
    _active = active;
    _role = role;
    _history = history;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _deviceToken = deviceToken;
}

  AdminUser.fromJson(dynamic json) {
    _location = json['location'] != null ? Location.fromJson(json['location']) : null;
    _id = json['_id'];
    _userName = json['userName'];
    _email = json['email'];
    _password = json['password'];
    _phone = json['phone'];
    _addresses = json['addresses'];
    _active = json['active'];
    _role = json['role'];
    if (json['history'] != null) {
      _history = [];
      json['history'].forEach((v) {
        _history?.add(v);
      });
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _deviceToken = json['deviceToken'];
  }
  Location? _location;
  String? _id;
  String? _userName;
  String? _email;
  String? _password;
  String? _phone;
  String? _addresses;
  bool? _active;
  String? _role;
  List<dynamic>? _history;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  String? _deviceToken;

  Location get location => _location??Location();
  String get id => _id??'';
  String get userName => _userName??'';
  String get email => _email??'';
  String get password => _password??'';
  String get phone => _phone??'';
  String get addresses => _addresses??'';
  bool get active => _active??false;
  String get role => _role??'';
  List<dynamic> get history => _history??[];
  String get createdAt => _createdAt??'';
  String get updatedAt => _updatedAt??'';
  num get v => _v??0;
  String get deviceToken => _deviceToken??'';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    map['_id'] = _id;
    map['userName'] = _userName;
    map['email'] = _email;
    map['password'] = _password;
    map['phone'] = _phone;
    map['addresses'] = _addresses;
    map['active'] = _active;
    map['role'] = _role;
    if (_history != null) {
      map['history'] = _history?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['deviceToken'] = _deviceToken;
    return map;
  }

}

Location locationFromJson(String str) => Location.fromJson(json.decode(str));
String locationToJson(Location data) => json.encode(data.toJson());
class Location {
  Location({
      List<dynamic>? coordinates,}){
    _coordinates = coordinates;
}

  Location.fromJson(dynamic json) {
    if (json['coordinates'] != null) {
      _coordinates = [];
      json['coordinates'].forEach((v) {
        _coordinates?.add(v);
      });
    }
  }
  List<dynamic>? _coordinates;

  List<dynamic> get coordinates => _coordinates??[];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_coordinates != null) {
      map['coordinates'] = _coordinates?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}