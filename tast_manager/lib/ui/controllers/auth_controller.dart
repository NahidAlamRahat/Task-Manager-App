import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tast_manager/data/models/user_data.dart';

class AuthController {
  static const String _tokenKey = 'access-token';
  static const String _userDataKey = 'user-data';

  static String? accessToken;
  static UserData? userModel;

  /// Save token and user data to SharedPreferences
  static Future<void> saveData(String accessToken, UserData userData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Save token
    await sharedPreferences.setString(_tokenKey, accessToken);

    // Save user data as JSON string
    await sharedPreferences.setString(_userDataKey, jsonEncode(userData.toJson()));
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
}
