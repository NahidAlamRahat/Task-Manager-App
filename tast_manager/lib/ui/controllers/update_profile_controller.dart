import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/user_data.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

// class UpdateProfileController extends GetxController{
//
//   bool  _isLoadingDataProgress =false;
//   bool get isLoadingDataProgress => _isLoadingDataProgress;
//   late String _message;
//   String get message => _message;
//   Future<bool> updateProfile({
//     required String firstName,
//     required String lastName,
//     required String mobile,
//      String? password,
//       XFile? image,
//   }) async {
//     bool isSuccess=false;
//     _isLoadingDataProgress = true;
//     update();
//
//     // Prepare the request body with updated profile data
//     Map<String, dynamic> requestBody = {
//       "firstName": firstName,
//       "lastName": lastName,
//       "mobile": mobile,
//     };
//
//     // Add image data if selected
//     if (image != null) {
//       List<int> imageBytes = await image.readAsBytes();
//       requestBody["photo"] = base64Encode(imageBytes);
//     }
//
//     // Add password if provided
//     if (password!.isNotEmpty) {
//       requestBody["password"] = password;
//     }
//
//     // Send the profile update request
//     final NetworkResponse networkResponse = await NetworkCaller.postRequest(
//       url: Urls.profileUpdateUrl,
//       body: requestBody,
//     );
//     print("Request Body: $requestBody");
//
//     _isLoadingDataProgress = false;
//     update();
//
//     if (networkResponse.isSuccess && networkResponse.statusData!.isNotEmpty) {
//       try {
//         final Map<String, dynamic> responseData = networkResponse.statusData?['data'] ?? {};
//
//         if (responseData.isNotEmpty) {
//           _message='Profile updated successfully';
//
//           // Update AuthController with new data
//           UserData updatedUserData = UserData.fromJson({
//             "email": AuthController.userModel?.email,
//             "firstName": firstName,
//             "lastName": lastName,
//             "mobile": mobile,
//             "photo": image != null
//                 ? base64Encode(await image!.readAsBytes())
//                 : AuthController.userModel?.photo,
//           });
//
//           await AuthController.saveData(AuthController.accessToken!, updatedUserData);
//
//           isSuccess = true;
//
//         } else {
//           _message='No data returned from server.';
//         }
//       } catch (e) {
//         _message= 'Unexpected response from server.';
//       }
//     } else {
//       _message= 'Failed to update profile. Please try again.';
//     }
//     return isSuccess;
//   }
//
//
//
// }

//=================================


class UpdateProfileController extends GetxController {
  // Tracks whether the data update process is ongoing
  bool _isLoadingDataProgress = false;
  bool get isLoadingDataProgress => _isLoadingDataProgress;
  AuthController authController = Get.put(AuthController());


  // Holds the message to display after the profile update operation
  late String _message;
  String get message => _message;

  /// Updates the user's profile
  /// - Accepts first name, last name, mobile number, password (optional), and image (optional)
  /// - Returns `true` if the profile update is successful, otherwise `false`
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String mobile,
    String? password,
    XFile? image,
  }) async {
    bool isSuccess = false; // Tracks if the operation was successful

    _isLoadingDataProgress = true; // Start loading
    update(); // Notify listeners about the state change

    // Prepare the request body with updated profile data
    Map<String, dynamic> requestBody = {
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    // If an image is provided, encode it as Base64 and include it in the request
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
      url: Urls.profileUpdateUrl, // API endpoint URL
      body: requestBody, // Request payload
    );
    print("Request Body: $requestBody"); // Debug log to track request payload

    _isLoadingDataProgress = false; // Stop loading
    update(); // Notify listeners about the state change

    // Handle the response from the server
    if (networkResponse.isSuccess && networkResponse.statusData!.isNotEmpty) {
      try {
        // Extract the response data from the network response
        final Map<String, dynamic> responseData = networkResponse.statusData?['data'] ?? {};

        if (responseData.isNotEmpty) {
          _message = 'Profile updated successfully';

          // Create an updated `UserData` instance
          UserData updatedUserData = UserData.fromJson({
            "email": authController.userModel.value?.email, // Retain the existing email
            "firstName": firstName, // Update the first name
            "lastName": lastName, // Update the last name
            "mobile": mobile, // Update the mobile number
            "photo": image != null
                ? base64Encode(await image.readAsBytes()) // Use the new photo if provided
                : authController.userModel.value?.photo, // Retain the existing photo if no new photo is provided
          });

          // Save the updated data to the `AuthController`
          await authController.saveData(AuthController.accessToken!, updatedUserData);

          isSuccess = true; // Mark the operation as successful
        } else {
          _message = 'No data returned from server.';
        }
      } catch (e) {
        _message = 'Unexpected response from server.'; // Handle unexpected server responses
      }
    } else {
      _message = 'Failed to update profile. Please try again.'; // Handle failed requests
    }
    return isSuccess;
  }
}
