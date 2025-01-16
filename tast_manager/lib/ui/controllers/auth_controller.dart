import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tast_manager/data/models/user_data.dart';

class AuthController{

 static const String _token = 'access-token';
 static const String _userData = 'access-token';

 static String? accessToken;
 static UserData? userModel;

 static Future<void> saveData(String AccessToken, UserData userData) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString(_token, AccessToken);
  await sharedPreferences.setString(_token, jsonEncode(userData.toJson()));

 }

 static Future<void> getUserData()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString(_token);
  String? userData = sharedPreferences.getString(_userData);

  accessToken = token;
  userModel= UserData.fromJson(jsonDecode(userData!));
 }


 static Future<bool> userLoggedIn() async{
  SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
 String? token= sharedPreferences.getString(_token);
 if(token!=null){
await getUserData();
return true;
 }
 else{
  return false;
 }

 }

 static Future<void> clearData()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
 }


}