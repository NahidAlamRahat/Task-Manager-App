import 'package:get/get.dart';
import 'package:tast_manager/data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class UpdateTodoStatusController extends GetxController{
late String _message;
 String get message=> _message ;
TaskListByStatusModel? _taskListByStatusModel;
List<TaskModel> get taskListModel => _taskListByStatusModel?.taskList ?? [];

  Future<bool> updateTodoStatus(String id, String status) async {
    bool updateTodoStatusIsSuccess = false;
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(id, status),
    );

    if (networkResponse.isSuccess) {
      _message = 'Update successful';
      _taskListByStatusModel?.status = status;
        update();
      updateTodoStatusIsSuccess = true;
    } else {
      _message = '${networkResponse.errorMessage}';
    }
    return updateTodoStatusIsSuccess;
  }


}