import 'package:tast_manager/data/models/task_model.dart';

/// Represents a list of tasks by a specific status
class TaskListByStatusModel {
  String? status;
  List<TaskModel>? taskList;

  TaskListByStatusModel({this.status, this.taskList});

  /// Json to Object
  TaskListByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskList = <TaskModel>[];
      json['data'].forEach((v) {
        taskList!.add(TaskModel.fromJson(v));
      });
    }
  }

  /// Object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (taskList != null) {
      data['data'] = taskList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
