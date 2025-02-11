import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class RecoverResetPasswordController extends GetxController{
  late String _message;
  String get message => _message;

  /// Sends the new password along with the OTP to reset the password.
  Future<bool> postResetPassword(
      {required String email,
      required String otp,
      required String password}) async {
    bool resetPasswordIsSuccess = false;
    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp,
      "password": password,
    };

    NetworkResponse networkResponse = await NetworkCaller.postRequest(
        url: Urls.recoverResetPassUrl, body: requestBody);

    debugPrint('email=> $email');
    debugPrint('OTP=> $otp');

    if (networkResponse.statusData?['status'] == 'success') {
      _message='Password changed successfully.';
      return resetPasswordIsSuccess=true;
    } else {
      _message= 'Request failed. Please try again!';
    }
    return resetPasswordIsSuccess;
  }


}