import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? statusData;
  final String? errorMessage;

  NetworkResponse(
      {required this.statusCode,
      required this.isSuccess,
      this.statusData,
      this.errorMessage});
}

class NetworkCaller {
  static Future<NetworkResponse> getRequest(
      {required String url, Map<String, dynamic>? params})
  async {
    try {
      Uri uri = Uri.parse(url);
      debugPrint('URl = $url');
      Response response = await get(uri);
      debugPrint('Status Code = ${response.statusCode}');
      debugPrint('Status Data = ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: decodedData,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }


  static Future<NetworkResponse> postRequest(
      {required String url, Map<String, dynamic>? body})
  async {
    try {
      Uri uri = Uri.parse(url);
      debugPrint('URl = $url');
      Response response = await post(uri, body: jsonEncode(body),
        headers: {
        'content-type': 'application/json'
        }
      );
      debugPrint('Status Code = ${response.statusCode}');
      debugPrint('Status Data = ${response.body}');
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: decodedData,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
}
