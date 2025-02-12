import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/user_data.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool _isLoadingDataProgress = false;
  bool get isLoadingDataProgress => _isLoadingDataProgress;
  AuthController authController = Get.put(AuthController());
  late String _message;
  String get message => _message;

  /// Updates the user's profile
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String mobile,
    String? password,
    XFile? image,
  }) async {
    bool isSuccess = false;

    _isLoadingDataProgress = true;
    update();

    // Prepare the request body with updated profile data
    Map<String, dynamic> requestBody = {
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    // If an image is provided,
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      requestBody["photo"] = base64Encode(imageBytes);
    }

    // Add password if provided
    if (password!.isNotEmpty) {
      requestBody["password"] = password;
    }

    // Send the profile update request using the `NetworkCaller`
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
          _message = 'Profile updated successfully';

          // Create an updated `UserData` instance
          UserData updatedUserData = UserData.fromJson({
            "email": authController.userModel.value?.email,
            "firstName": firstName,
            "lastName": lastName,
            "mobile": mobile,
            "photo": image != null
                ? base64Encode(await image.readAsBytes())
                : authController.userModel.value?.photo, // Retain the existing photo if no new photo is provided
          });

          // Save the updated data to the `AuthController`
          await authController.saveData(AuthController.accessToken!, updatedUserData);

          isSuccess = true;
        } else {
          _message = 'No data returned from server.';
        }
      } catch (e) {
        _message = 'Unexpected response from server.';
      }
    } else {
      _message = 'Failed to update profile. Please try again.';
    }
    return isSuccess;
  }
}
