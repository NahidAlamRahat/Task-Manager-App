// import 'dart:ffi';
//
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:tast_manager/ui/controllers/get_task_list_controller.dart';
//
// import '../../data/models/task_count_by_status_model.dart';
// import '../../data/models/task_count_model.dart';
// import '../../data/models/task_list_by_status_model.dart';
// import '../../data/models/task_model.dart';
// import '../../data/services/network_caller.dart';
// import '../../data/utils/urls.dart';
//
// class NewTaskListController extends GetxController {
//   final GetTaskListController getTaskListController = GetTaskListController();
//
//  bool isLoadingDataProgress = false;
//   TaskCountByStatusModel? _taskCountByStatusModel;
//   List<TaskCountModel> get taskCountModel => _taskCountByStatusModel?.taskByStatusList ?? [];
//
//   TaskListByStatusModel? _taskListByStatusModel;
//   List<TaskModel> get taskListModel => _taskListByStatusModel?.taskList ?? [];
//
//   late String _message;
//   String get message => _message;
//
//   Future<bool> getTaskCountByStatus({bool isFromRefresh = false}) async {
//     bool getTaskCountByStatusIsSuccess = false;
//     if (!isFromRefresh) {
//       isLoadingDataProgress= true;
//     }
//
//     NetworkResponse networkResponse = await NetworkCaller.getRequest(url: Urls.taskStatusCountUrl);
//
//     if (networkResponse.isSuccess) {
//       _taskCountByStatusModel = TaskCountByStatusModel.fromJson(networkResponse.statusData!);
//       getTaskCountByStatusIsSuccess = true;
//     } else {
//       _message = '${networkResponse.errorMessage}';
//     }
//
//     isLoadingDataProgress = false;
//     update();
//     return getTaskCountByStatusIsSuccess;
//   }
//
//
//   /// Fetches the new task list from the network
//   Future<bool> getTaskList({required bool isFromRefresh, required String statusName}) async {
//     bool getTaskListIsSuccess = false;
//     if (!isFromRefresh) {
//       isLoadingDataProgress = true;
//       update();
//     }
//
//     NetworkResponse networkResponse =
//     await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl(statusName));
//
//     if (networkResponse.isSuccess) {
//       _taskListByStatusModel =
//           TaskListByStatusModel.fromJson(networkResponse.statusData!);
//       getTaskListIsSuccess = true;
//       update();
//     } else {
//       _message = '${networkResponse.errorMessage}';
//     }
//
//     isLoadingDataProgress = false;
//     update();
//     return getTaskListIsSuccess;
//   }
//
// }

//-===================================

import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tast_manager/ui/controllers/get_task_list_controller.dart';

import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_count_model.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class NewTaskListController extends GetxController {
  var isLoading = false.obs; // Observable isLoading
  var taskListModel = <TaskModel>[].obs; // Observable task list
  var taskCountModel = <TaskCountModel>[].obs; // Observable task count
  var isAppBarRebuilt = false.obs; // Flag to control app bar rebuild

  /// Task count fetch korar jonno method
  Future<bool> getTaskCountByStatus({bool isFromRefresh = false}) async {
    try {
      isLoading.value = true; // Loading start
      NetworkResponse networkResponse = await NetworkCaller.getRequest(url: Urls.taskStatusCountUrl);
      if (networkResponse.isSuccess) {
        taskCountModel.value = TaskCountByStatusModel.fromJson(networkResponse.statusData!).taskByStatusList!;
        isLoading.value = false; // Loading shesh
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false; // Error hoileo loading false
      return false;
    }
  }

  /// Task list fetch korar jonno method
  Future<bool> getTaskList({bool isFromRefresh = false, required String statusName}) async {
    try {
      isLoading.value = true; // Loading start
      NetworkResponse networkResponse = await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl(statusName));
      if (networkResponse.isSuccess) {
        taskListModel.value = TaskListByStatusModel.fromJson(networkResponse.statusData!).taskList!;
        isLoading.value = false; // Loading shesh
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false; // Error hoileo loading false
      return false;
    }
  }

}
