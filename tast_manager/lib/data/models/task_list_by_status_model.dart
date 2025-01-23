import 'package:tast_manager/data/models/task_model.dart';

/// Represents a list of tasks grouped by a specific status
class TaskListByStatusModel {
  String? status; // The status/category of the tasks (e.g., "New", "Completed")
  List<TaskModel>? taskList; // The list of tasks under this status

  /// Constructor to initialize with optional values
  TaskListByStatusModel({this.status, this.taskList});

  /// Creates a TaskListByStatusModel object from JSON data
  TaskListByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status']; // Extract the task status from JSON
    if (json['data'] != null) {
      taskList = <TaskModel>[]; // Initialize the task list
      json['data'].forEach((v) {
        taskList!.add(TaskModel.fromJson(v)); // Add each task to the list
      });
    }
  }

  /// Converts this object to JSON format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status; // Add the task status to JSON
    if (taskList != null) {
      data['data'] = taskList!.map((v) => v.toJson()).toList(); // Add tasks to JSON
    }
    return data;
  }
}

