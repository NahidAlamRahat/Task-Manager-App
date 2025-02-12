import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tast_manager/ui/controllers/update_todo_status_controller.dart';
import 'package:tast_manager/widgets/show_custom_alert_dialog.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';
import '../data/models/task_model.dart';
import '../ui/controllers/delete_item_controller.dart';

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({
    super.key,
    required this.taskModel,
    required this.color,
    required this.status,
    required this.showEditButton,
  });

  final TaskModel? taskModel;
  final Color color;
  final String status;
  final bool showEditButton;

  @override
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

final UpdateTodoStatusController _updateTodoStatusController = Get.find<UpdateTodoStatusController>();
final DeleteItemController _deleteItemController = Get.find<DeleteItemController>();

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.taskModel?.title ?? 'empty'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel?.description ?? 'empty',
              style: const TextStyle(color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(widget.taskModel?.createdDate ?? 'empty'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: Text(widget.status),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    backgroundColor: widget.color,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _deletedItemAlertDialog();
                        },
                        icon: const Icon(Icons.delete)),

                    if (widget.showEditButton) // Conditionally show edit button
                      IconButton(
                        onPressed: () {
                          _showChangeStatusDialog(id: widget.taskModel?.sId);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeStatusDialog({required String? id}) {
    if (id == null) {
      Mymessage('Invalid Task ID', context);
      return;
    }

    List<String> availableStatuses = [];
    if (widget.status == 'New') {
      availableStatuses = ['Progress', 'Completed', 'Canceled'];
    } else if (widget.status == 'Progress') {
      availableStatuses = ['Completed', 'Canceled'];
    } else if (widget.status == 'Completed') {
      availableStatuses = ['Canceled'];
    }

    ///change status
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (String status in availableStatuses) ...[
                const Divider(height: 0),
                ListTile(
                  title: Text(status),
                  onTap: () {
                    _updateTodoStatus(id, status);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  _deletedItemAlertDialog(){
    showCustomAlertDialog(context, text: const Text('Delete Task!'),
        message: 'Are you sure you want to delete this task?',
        onConfirm: (){
          _getDeleteItem(id: widget.taskModel?.sId);
          Get.back(result: true);
        }
    );
  }


  /// Item Status Updated Method.
  Future<void> _updateTodoStatus(var id, String status) async {
    bool updateTodoStatusIsSuccess =await _updateTodoStatusController.updateTodoStatus(id, status) ;

    if (updateTodoStatusIsSuccess) {
      _updateTodoStatusController.message;
     Get.back();
    } else {
    _updateTodoStatusController.message;
    }
  }

  /// Item Status Deleted Method.
  Future<void> _getDeleteItem({required var id}) async{
    bool deleteItemIsSuccess =await _deleteItemController.getDeleteItem(id: id);
    if(deleteItemIsSuccess){
      Mymessage(_deleteItemController.message, context);

    }
    else{
      Mymessage(_deleteItemController.message, context);
    }
  }

}
