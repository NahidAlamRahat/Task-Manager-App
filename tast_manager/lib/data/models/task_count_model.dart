/// A model class to represent the task count for a specific status
class TaskCountModel {
  String? sId; // ID of the task status or category
  int? sum; // Total number of tasks for this ID

  /// Constructor to initialize with optional values
  TaskCountModel({this.sId, this.sum});

  /// Creates a TaskCountModel object from JSON data
  TaskCountModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id']; // Get the ID from JSON
    sum = json['sum']; // Get the task count from JSON
  }

  /// Converts this object to JSON format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId; // Add ID to JSON
    data['sum'] = sum; // Add task count to JSON
    return data;
  }
}

