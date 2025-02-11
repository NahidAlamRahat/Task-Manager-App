import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../../widgets/show_snackber_message.dart';


class SignUpController extends GetxController{
  bool singUpInProgress = false;
  late String _message;
  String get message => _message;


  Future<bool> singUp({
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    required String password,
    XFile? image,
  }) async {
    bool singUpIsSuccess = false;
    singUpInProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };
    if(image != null){
      List<int> imageBytes = await image.readAsBytes();
      requestBody["photo"]= base64Encode(imageBytes);
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.registrationUrl, body: requestBody);

    singUpInProgress = false;
    update();

    if (response.isSuccess) {
      _message='$firstName Your Registration Completed';
      singUpIsSuccess = true;
    } else {
      _message='Something went wrong! Please try again';
    }
    return singUpIsSuccess;
  }

}