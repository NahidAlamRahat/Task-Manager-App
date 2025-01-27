/// A model class to represent the task count for a specific status
class TaskCountModel {
  String? sId;
  int? sum;

  TaskCountModel({this.sId, this.sum});

  /// Creates a TaskCountModel object from JSON data
  TaskCountModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }

  /// Converts this object to JSON format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['sum'] = sum;
    return data;
  }
}
