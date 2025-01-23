import 'package:tast_manager/data/models/task_count_model.dart';

/// A model class to represent the task count grouped by status
class TaskCountByStatusModel {
  String? status; // Status of the tasks (e.g., "New", "Progress", "Completed")
  List<TaskCountModel>? taskByStatusList; // List of task counts for the given status

  /// Constructor to initialize the model
  TaskCountByStatusModel({this.status, this.taskByStatusList});

  /// Factory constructor to create an instance from a JSON object
  TaskCountByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status']; // Assign the status field from JSON data
    if (json['data'] != null) {
      // Initialize the list if JSON data is not null
      taskByStatusList = <TaskCountModel>[];
      // Loop through each item in the JSON data and create `TaskCountModel` instances
      json['data'].forEach((v) {
        taskByStatusList!.add(TaskCountModel.fromJson(v));
      });
    }
  }

  /// Converts the model instance to a JSON object
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status; // Add the status field to JSON
    if (this.taskByStatusList != null) {
      // Map the list of `TaskCountModel` to JSON objects and add it to JSON
      data['data'] = this.taskByStatusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

