import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';

import '../data/models/task_model.dart';
import '../data/services/network_caller.dart';
import '../data/utils/urls.dart';

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({
    super.key,
    required this.taskModel, // Represents the task data to be displayed
    required this.color, // The color associated with the task's status
    required this.status, // The current status of the task
    required this.showEditButton, // Determines whether the edit button is shown
  });

  final TaskModel? taskModel; // Task model containing task data
  final Color color; // Color to represent the task's status
  final String status; // Task's current status
  final bool showEditButton; // Flag to show or hide the edit button

  @override
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    // Builds the widget structure for displaying the task item
    return Card(
      child: ListTile(
        title: Text(widget.taskModel?.title ?? 'empty'), // Displays the task title
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displays the task description
            Text(
              widget.taskModel?.description ?? 'empty',
              style: const TextStyle(color: Colors.grey),
              maxLines: 2, // Limits to two lines with ellipsis if overflowing
              overflow: TextOverflow.ellipsis,
            ),
            Text(widget.taskModel?.createdDate ?? 'empty'), // Displays the creation date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Displays a chip to show the task's status
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners for the chip
                    ),
                    label: Text(widget.status), // Status label
                    labelStyle: const TextStyle(
                      color: Colors.white, // White text color
                      fontSize: 16, // Font size
                    ),
                    backgroundColor: widget.color, // Chip background color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4, // Horizontal padding inside the chip
                      vertical: 2, // Vertical padding inside the chip
                    ),
                  ),
                ),
                // Row containing action buttons (delete and optionally edit)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {}, // Placeholder for delete functionality
                      icon: const Icon(Icons.delete), // Delete icon
                    ),
                    if (widget.showEditButton) // Conditionally show the edit button
                      IconButton(
                        onPressed: () {
                          // Show a dialog for changing task status
                          _showChangeStatusDialog(id: widget.taskModel?.sId);
                        },
                        icon: const Icon(Icons.edit), // Edit icon
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

  /// Shows a dialog to change the task's status.
  void _showChangeStatusDialog({required String? id}) {
    if (id == null) {
      // Show an error message if the task ID is invalid
      Mymessage('Invalid Task ID', context);
      return;
    }

    // Determine the available statuses based on the current task status
    List<String> availableStatuses = [];
    if (widget.status == 'New') {
      availableStatuses = ['Progress', 'Completed', 'Canceled'];
    } else if (widget.status == 'Progress') {
      availableStatuses = ['Completed', 'Canceled'];
    } else if (widget.status == 'Completed') {
      availableStatuses = ['Canceled'];
    }

    // Show a dialog to select a new status
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Status'), // Dialog title
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (String status in availableStatuses) ...[ // List available statuses
                const Divider(height: 0), // Divider between options
                ListTile(
                  title: Text(status), // Status option text
                  onTap: () {
                    // Update the task status when an option is selected
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

  /// Updates the task's status by making a network request.
  void _updateTodoStatus(String id, String status) async {
    // Send a network request to update the status
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(id, status),
    );

    if (networkResponse.isSuccess) {
      // Show a success message and update the status locally
      Mymessage('Update successful', context);
      setState(() {
        widget.taskModel?.status = status; // Update status locally
        Navigator.pop(context); // Close the dialog
      });
    } else {
      // Show an error message if the update fails
      Mymessage(networkResponse.errorMessage, context);
    }
  }
}