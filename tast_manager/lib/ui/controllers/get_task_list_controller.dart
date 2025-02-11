import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class GetTaskListController extends GetxController{
  bool isLoadingDataProgress = false;
  late String _message;
  String get message => _message;

  TaskListByStatusModel? _taskListByStatusModel;
  List<TaskModel> get taskListModel => _taskListByStatusModel?.taskList ?? [];

  /// Fetches the new task list from the network
  Future<bool> getTaskList({required bool isFromRefresh, required String statusName}) async {
    bool getTaskListIsSuccess = false;
    if (!isFromRefresh) {
      isLoadingDataProgress = true;
      update();
    }

    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl(statusName));

    if (networkResponse.isSuccess) {
      _taskListByStatusModel =
          TaskListByStatusModel.fromJson(networkResponse.statusData!);
      getTaskListIsSuccess = true;// Set success
      update();
    } else {
      _message = '${networkResponse.errorMessage}'; // Set error message
    }

    isLoadingDataProgress = false;
    update();
    return getTaskListIsSuccess;
  }


}


