import 'package:get/get.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_count_model.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class NewTaskListController extends GetxController {
  var isLoading = false.obs;
  var taskListModel = <TaskModel>[].obs;
  var taskCountModel = <TaskCountModel>[].obs;
  var isAppBarRebuilt = false.obs;

  /// Task count fetch korar jonno method
  Future<bool> getTaskCountByStatus({bool isFromRefresh = false}) async {
    try {
      isLoading.value = true;
      NetworkResponse networkResponse = await NetworkCaller.getRequest(url: Urls.taskStatusCountUrl);
      if (networkResponse.isSuccess) {
        taskCountModel.value =
            TaskCountByStatusModel.fromJson(networkResponse.statusData!)
                .taskByStatusList!;
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  /// Task list fetch korar jonno method
  Future<bool> getTaskList({bool isFromRefresh = false, required String statusName}) async {
    try {
      isLoading.value = true;
      NetworkResponse networkResponse = await NetworkCaller.getRequest(
          url: Urls.taskListByStatusUrl(statusName));
      if (networkResponse.isSuccess) {
        taskListModel.value = TaskListByStatusModel.fromJson(networkResponse.statusData!).taskList!;
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

}
