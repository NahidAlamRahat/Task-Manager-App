import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tast_manager/app.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';

/// Represents the response structure for network requests
class NetworkResponse {
  final bool isSuccess; // Indicates if the request was successful
  final int statusCode; // HTTP status code of the response
  late final Map<String, dynamic>? statusData; // Decoded JSON data from the response
  final String? errorMessage; // Error message if the request fails

  NetworkResponse({
    required this.statusCode,
    required this.isSuccess,
    this.statusData,
    this.errorMessage,
  });
}

/// A utility class for making network requests
class NetworkCaller {
  /// Sends a GET request to the given [url].
  /// [params] are optional query parameters.
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

      // Handle successful response
      if (response.statusCode == 200) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: jsonDecode(response.body), // Decode JSON response
        );
      }
      // Handle unauthorized (401) response
      else if (response.statusCode == 401) {
        await _logOut(); // Log the user out and redirect to sign-in
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: jsonDecode(response.body),
        );
      }
      // Handle other errors
      else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (e) {
      // Handle request failure
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(), // Capture the error message
      );
    }
  }


  /// Sends a POST request to the given [url].
  /// [body] is the request payload, which will be encoded as JSON.
  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url); // Parse the URL
      debugPrint('URL = $url');

      // Send POST request with JSON-encoded body and authorization token
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

      // Handle successful response
      if (response.statusCode == 200) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: jsonDecode(response.body), // Decode JSON response
        );
      }
      // Handle unauthorized (401) response
      else if (response.statusCode == 401) {
        await _logOut(); // Log the user out and redirect to sign-in
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          statusData: jsonDecode(response.body),
        );
      }
      // Handle other errors
      else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (e) {
      // Handle request failure
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(), // Capture the error message
      );
    }
  }

  /// Logs the user out and redirects to the sign-in screen.
  static Future<void> _logOut() async {
    // Clear stored authentication data
    await AuthController.clearData();

    // Redirect to SignInScreen
    Navigator.pushNamedAndRemoveUntil(
      TaskManager.navigatorKey.currentContext!,
      SignInScreen.name,
          (route) => false, // Remove all previous routes
    );

    debugPrint("User logged out and redirected to SignInScreen.");
  }
}

