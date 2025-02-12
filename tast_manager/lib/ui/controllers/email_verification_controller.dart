import 'package:get/get.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class EmailVerificationController extends GetxController{
late String _message;
String get message => _message;

  Future<bool> emailVerification({required String email}) async {
    bool emailVerificationIsSuccess = false;
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyEmailUrl(email));
    if (networkResponse.isSuccess) {
      _message= 'Check your email';
      emailVerificationIsSuccess=true;
    } else {
      _message = 'There is an error. Please try again. ${networkResponse.errorMessage}';

    }
    return emailVerificationIsSuccess;
  }

}