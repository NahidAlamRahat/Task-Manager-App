import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class AddNewTaskController extends GetxController{
 bool _newTaskAddedInProgress = false;
 bool get newTaskAddedInProgress=>_newTaskAddedInProgress;
 late String _message;
 String get message => _message;

  Future<bool> addNewTaskItem({required String title, required String description}) async {
    bool addNewTaskItemIsSuccess =false;
    _newTaskAddedInProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": "New",
    };

    final NetworkResponse networkResponse = await NetworkCaller.postRequest(
        url: Urls.createTaskUrl, body: requestBody);

    _newTaskAddedInProgress = false;
    update();

    if (networkResponse.isSuccess) {
      _message= 'New Task Added';
      return addNewTaskItemIsSuccess = true;
    } else {
      debugPrint(networkResponse.errorMessage);
      debugPrint(networkResponse.statusCode.toString());
    _message= 'Added field';
    }
    return addNewTaskItemIsSuccess;
  }

}