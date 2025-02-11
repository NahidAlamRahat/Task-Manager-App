import 'dart:convert';
import 'package:get/get.dart';
import '../../data/models/user_data.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../screen/bottom_nav_screen/main_bottom_nav_screen.dart';
import 'auth_controller.dart';

class SignInController extends GetxController{

  bool _signInProgress = false;
  bool get signInProgress => _signInProgress;
  AuthController authController = Get.put(AuthController());

  late String _message;
  String get message=> _message;


  Future<bool> logInRequest(String  email, password) async {
    bool isSuccess=false;
    _signInProgress = true;
    update();

    Map<String, dynamic> requestLogInBody = {
      "email": email,
      "password": password,
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(url: Urls.loginUrl, body: requestLogInBody);

    _signInProgress = false;
    update();

    if (response.isSuccess) {
      if (response.statusData is String) {
        try {
          response.statusData = jsonDecode(response.statusData as String);
        } catch (e) {
          _message='Unexpected response from server.${e.toString()}';
          return false;
        }
      }

      String? token = response.statusData?['token'];
      UserData? userData = UserData.fromJson(response.statusData?['data'] ?? {});

      if (token != null) {
        await authController.saveData(token, userData);
        // Mymessage('LogIn Success', context);
        _message='LogIn Success';
        isSuccess =true;
      } else {
        // Mymessage('Email/Password Invalid. Please try again!', context);
        _message ='Email/Password Invalid. Please try again!';
      }
    }
    return isSuccess;
  }


}