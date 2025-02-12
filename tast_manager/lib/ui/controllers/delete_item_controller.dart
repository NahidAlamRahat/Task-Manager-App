import 'package:get/get.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class DeleteItemController extends GetxController{
  late String _message;
  String get message=> _message ;
  TaskListByStatusModel? _taskListByStatusModel;
  List<TaskModel> get taskListModel => _taskListByStatusModel?.taskList ?? [];

  Future<bool> getDeleteItem({required var id}) async{
    bool deleteItemIsSuccess = false;
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.deleteTaskUrl(id));
    print('deleted id=> $id');
    print('statusCode=> ${networkResponse.statusCode}');
    print('errorMessage id=> ${networkResponse.errorMessage}');


    if(networkResponse.isSuccess){
      taskListModel.removeAt(id);
      _message= 'Delete Successfully';
      deleteItemIsSuccess = true;
    }
    else{
      _message= 'deleted error';
    }
    return deleteItemIsSuccess;
  }


}