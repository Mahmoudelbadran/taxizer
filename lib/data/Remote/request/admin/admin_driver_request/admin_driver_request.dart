import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/contant/constant.dart';
import '../../../../../core/end_point/end_point.dart';
import '../../../response/admin/admin_driver_response/admin_driver_response.dart';

class AdminDriverRequest {
  Future adminDriverRequest({
    required String token,

  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrlUser/$driverRequests"),
        headers: {'Content-Type': 'application/json',
          'Authorization':'Bearer $token'
        },

      );
      print(response.body);
      return AdminDriverResponse.fromJson(jsonDecode(response.body));

    } catch (error) {
      if (kDebugMode) {
        print(error);
        print("this error api:$error");
      }
    }
  }
}