import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tast_manager/app.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';

/// Represents the response structure for network requests
class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  late final Map<String, dynamic>? statusData;
  String? errorMessage;

  NetworkResponse({
    required this.statusCode,
    required this.isSuccess,
    this.statusData,
    this.errorMessage,
  });
}


class NetworkCaller {

  /// Sends a GET request
  static Future<NetworkResponse> getRequest({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      final uri = Uri.parse(url); // Parse the URL
      debugPrint('URL = $url');

      // Send GET request with an authorization token
      Response response =
      await get(uri, headers: {'token': AuthController.accessToken ?? ''});

      debugPrint('Status Code = ${response.statusCode}');
      debugPrint('Response Data = ${response.body}');

      if (response.statusCode == 200) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: jsonDecode(response.body),
        );
      }
      // Handle unauthorized (401) response
      else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: jsonDecode(response.body),
        );
      }
      else {
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


  /// Sends a POST request to the [url].
  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url); // Parse the URL
      debugPrint('URL = $url');

      Response response = await post(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'token': AuthController.accessToken ?? ''
        },
      );

      debugPrint('Status Code = ${response.statusCode}');
      debugPrint('Response Data = ${response.body}');


      if (response.statusCode == 200) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: jsonDecode(response.body),
        );
      }
      // Handle unauthorized (401) response
      else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: jsonDecode(response.body),
        );
      }
      else {
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

 /// [Token_expired] Logout the user and go to the sign-in screen.
  static Future<void> _logOut() async {
    // Clear data
    await AuthController.clearData();
    Navigator.pushNamedAndRemoveUntil(
      TaskManager.navigatorKey.currentContext!,
      SignInScreen.name,
          (route) => false,
    );

  }
}

