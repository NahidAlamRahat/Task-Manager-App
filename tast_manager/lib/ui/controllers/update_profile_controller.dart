import 'dart:convert';
import 'package:get/get.dart';
import '../../data/models/user_data.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController{

  bool  _isLoadingDataProgress =false;
  bool get isLoadingDataProgress => _isLoadingDataProgress;
  late String _message;
  String get message => _message;


  Future<bool> updateProfile(String firstName, String lastName, String mobile,String password, ) async {
    bool isSuccess=false;
    _isLoadingDataProgress = true;
    update();

    // Prepare the request body with updated profile data
    Map<String, dynamic> requestBody = {
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    // Add image data if selected
    // if (image != null) {
    //   List<int> imageBytes = await image!.readAsBytes();
    //   requestBody["photo"] = base64Encode(imageBytes);
    // }

    // Add password if provided
    if (password.isNotEmpty) {
      requestBody["password"] = password;
    }

    // Send the profile update request
    final NetworkResponse networkResponse = await NetworkCaller.postRequest(
      url: Urls.profileUpdateUrl,
      body: requestBody,
    );
    print("Request Body: $requestBody");

    _isLoadingDataProgress = false;
    update();

    if (networkResponse.isSuccess && networkResponse.statusData!.isNotEmpty) {
      try {
        final Map<String, dynamic> responseData = networkResponse.statusData?['data'] ?? {};

        if (responseData.isNotEmpty) {
          UserData updatedUserData = UserData.fromJson({
            "email": AuthController.userModel?.email,
            "firstName": responseData['firstName'] ?? AuthController.userModel?.firstName,
            "lastName": responseData['lastName'] ?? AuthController.userModel?.lastName,
            "mobile": responseData['mobile'] ?? AuthController.userModel?.mobile,
            "photo": responseData['photo'] ?? AuthController.userModel?.photo,
          });

          await AuthController.saveData(AuthController.accessToken!, updatedUserData);

          _message='Profile updated successfully';
          isSuccess = true;

          print('Updated User Data:');
          print('Email: ${AuthController.userModel?.email}');
          print('First Name: ${AuthController.userModel?.firstName}');
          print('Last Name: ${AuthController.userModel?.lastName}');
          print('Mobile: ${AuthController.userModel?.mobile}');
          print('Photo: ${AuthController.userModel?.photo}');
        } else {
          _message='No data returned from server.';
        }
      } catch (e) {
        _message= 'Unexpected response from server.';
      }
    } else {
      _message= 'Failed to update profile. Please try again.';
    }
    return isSuccess;
  }



}