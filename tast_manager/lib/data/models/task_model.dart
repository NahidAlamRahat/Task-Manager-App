/// Represents a single task with its details
class TaskModel {
  String? sId; // The unique identifier for the task
  String? title; // The title or name of the task
  String? description; // A brief description of the task
  String? status; // The current status of the task (e.g., "New", "Completed")
  String? createdDate; // The date when the task was created

  /// Constructor to initialize a task with optional fields
  TaskModel({
    this.sId,
    this.title,
    this.description,
    this.status,
    this.createdDate,
  });

  /// Creates a TaskModel object from JSON data
  TaskModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id']; // Assign the task ID from JSON
    title = json['title']; // Assign the task title from JSON
    description = json['description']; // Assign the task description from JSON
    status = json['status']; // Assign the task status from JSON
    createdDate = json['createdDate']; // Assign the task creation date from JSON
  }

  /// Converts the TaskModel object to a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId; // Add the task ID to JSON
    data['title'] = title; // Add the task title to JSON
    data['description'] = description; // Add the task description to JSON
    data['status'] = status; // Add the task status to JSON
    data['createdDate'] = createdDate; // Add the task creation date to JSON
    return data;
  }
}
