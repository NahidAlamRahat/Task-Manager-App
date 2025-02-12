import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class ForgetPassPinVerificationController extends GetxController{
  late String _message;
  String get message => _message;

  Future<bool> getPinVerify({required String email, required String otp}) async {
    bool getPinVerifyIsSuccess = false;
    // API Call
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyOTP(email, otp));

    if (networkResponse.statusData?['status'] == 'success') {
    getPinVerifyIsSuccess = true;
    } else {
      _message= 'Invalid OTP. Please try again.';
    }
    return getPinVerifyIsSuccess;
  }


}