import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tast_manager/data/models/user_data.dart';

import '../../data/services/network_caller.dart';

//mainta
/*class AuthController {
  static const String _tokenKey = 'access-token';
  static const String _userDataKey = 'user-data';

  static String? accessToken;
  static UserData? userModel;

  Rx<UserData?> userModel = userModel.obs; // Reactive property


  /// Save token and user data to SharedPreferences
  static Future<void> saveData(String token, UserData userData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Save token
    await sharedPreferences.setString(_tokenKey, token);
    accessToken = token; // Update static accessToken variable

    // Save user data as JSON string
    await sharedPreferences.setString(_userDataKey, jsonEncode(userData.toJson()));
    userModel = userData; // Update static userModel variable
  }


  /// Retrieve user data and token from SharedPreferences
  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Retrieve token
    String? token = sharedPreferences.getString(_tokenKey);

    // Retrieve user data
    String? userDataJson = sharedPreferences.getString(_userDataKey);

    if (token != null && userDataJson != null) {
      accessToken = token;
      userModel = UserData.fromJson(jsonDecode(userDataJson));
    }
  }

  /// Check if the user is logged in by verifying the presence of a token
  static Future<bool> userLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Check for token existence
    String? token = sharedPreferences.getString(_tokenKey);

    if (token != null) {
      await getUserData(); // Load user data if token exists
      return true;
    } else {
      return false;
    }
  }

  /// Clear user data and token from SharedPreferences
  static Future<void> clearData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userDataKey);

    accessToken = null;
    userModel = null;
  }
}*/

//============================

class AuthController extends GetxController {
  static const String _tokenKey = 'access-token';
  static const String _userDataKey = 'user-data';

  static String? accessToken;

  // Make userModel reactive
  Rx<UserData?> userModel = Rx<UserData?>(null);
  RxBool isLoading = false.obs;


  /// Save token and user data to SharedPreferences
  Future<void> saveData(String token, UserData userData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Save token
    await sharedPreferences.setString(_tokenKey, token);
    accessToken = token; // Update static accessToken variable

    // Save user data as JSON string
    await sharedPreferences.setString(_userDataKey, jsonEncode(userData.toJson()));
    userModel.value = userData; // Update reactive userModel
  }

  /// Retrieve user data and token from SharedPreferences
  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Retrieve token
    String? token = sharedPreferences.getString(_tokenKey);

    // Retrieve user data
    String? userDataJson = sharedPreferences.getString(_userDataKey);

    if (token != null && userDataJson != null) {
      accessToken = token;
      userModel.value = UserData.fromJson(jsonDecode(userDataJson)); // Update reactive userModel
    }
  }

  /// Check if the user is logged in by verifying the presence of a token
  Future<bool> userLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Check for token existence
    String? token = sharedPreferences.getString(_tokenKey);

    if (token != null) {
      await getUserData(); // Load user data if token exists
      return true;
    } else {
      return false;
    }
  }

  /// Clear user data and token from SharedPreferences
  Future<void> clearData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userDataKey);

    accessToken = null;
    userModel.value = null; // Clear reactive userModel
  }
}

