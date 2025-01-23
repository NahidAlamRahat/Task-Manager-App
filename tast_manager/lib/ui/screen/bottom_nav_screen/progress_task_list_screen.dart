import 'package:flutter/material.dart';
import 'package:tast_manager/data/models/task_count_by_status_model.dart';
import 'package:tast_manager/data/models/task_count_model.dart';
import 'package:tast_manager/data/models/task_model.dart';
import 'package:tast_manager/data/services/network_caller.dart';
import 'package:tast_manager/data/utils/urls.dart';
import 'package:tast_manager/ui/screen/add_new_task_screen.dart';
import 'package:tast_manager/widgets/TaskStatusSummaryCounterWidget.dart';
import 'package:tast_manager/widgets/background_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';
import 'package:tast_manager/widgets/task_item_widget.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';
import '../../../data/models/task_list_by_status_model.dart';

/// Screen displaying tasks in the "Progress" status, with summary of task counts.
class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _getTasksSummaryByStatusProgress = false;  // Flag for showing loading progress

  TaskCountByStatusModel? taskCountByStatusModel;  // Holds task count by status
  TaskListByStatusModel? taskListModel;  // Holds task list by status
  TaskModel? taskModel;  // Placeholder for individual task model

  /// Refreshes both task count and list views when pulling to refresh.
  Future<void> _refreshAllData() async {
    // Refresh task count and task list without modifying loading state
    await _getTaskCountByStatus(isFromRefresh: true);
    await _getCompletedTaskListView(isFromRefresh: true);
  }

  @override
  void initState() {
    super.initState();
    // Initialize task count and task list by status
    _getTaskCountByStatus(isFromRefresh: false);
    _getCompletedTaskListView(isFromRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme),  // Custom app bar for task manager
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigates to the screen to add a new task
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: const Icon(Icons.add),  // Icon for the floating action button
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAllData,  // Enables pull-to-refresh functionality
        child: BackgroundScreen(
          child: Column(
            children: [
              SizedBox(
                  height: 100,
                  child: _buildTasksSummaryByStatus()),  // Display task summary by status
              _buildTaskListView(),  // Display list of tasks
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the task list view displaying tasks in "Progress" status.
  Widget _buildTaskListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ListView.builder(
            shrinkWrap: true,  // Prevents scrolling issues by limiting list size
            primary: false,
            itemCount: taskListModel?.taskList?.length ?? 0,  // Safely access task list length
            itemBuilder: (context, index) {
              return TaskItemWidget(
                color: const Color.fromRGBO(203, 12, 159, 1),  // Custom color for the task item widget
                taskModel: taskListModel?.taskList?[index],  // Pass the task model for the individual task
                status: 'Progress',  // Status of task
                showEditButton: true,  // Show the edit button for each task
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the summary of tasks by their status.
  Widget _buildTasksSummaryByStatus() {
    return Visibility(
      visible: _getTasksSummaryByStatusProgress == false,  // Only show the summary when data is ready
      replacement: const Center(child: CircularProgressIndicator()),  // Shows loading indicator while fetching data
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,  // Horizontal scrolling for the task status counters
          itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,  // Safely access task count list
          itemBuilder: (context, index) {
            final TaskCountModel model = taskCountByStatusModel!.taskByStatusList![index];
            return TaskStatusSummaryCounterWidget(
              count: model.sum.toString(),  // Display the task count
              title: model.sId ?? '',  // Display the task status
            );
          },
        ),
      ),
    );
  }

  /// Fetches task count by status from the network and updates the state.
  Future<void> _getTaskCountByStatus({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _getTasksSummaryByStatusProgress = true;  // Show progress indicator while fetching data
      setState(() {});
    }

    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(url: Urls.taskStatusCountUrl);

    if (networkResponse.isSuccess) {
      taskCountByStatusModel = TaskCountByStatusModel.fromJson(networkResponse.statusData!);
    } else {
      Mymessage(networkResponse.errorMessage, context);  // Show error message if the request fails
    }

    _getTasksSummaryByStatusProgress = false;  // Hide progress indicator after the request completes
    setState(() {});
  }

  /// Fetches tasks in "Progress" status from the network and updates the state.
  Future<void> _getCompletedTaskListView({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _getTasksSummaryByStatusProgress = true;  // Show progress indicator while fetching data
      setState(() {});
    }

    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('Progress'));

    if (networkResponse.isSuccess) {
      taskListModel = TaskListByStatusModel.fromJson(networkResponse.statusData!);
    } else {
      Mymessage(networkResponse.errorMessage, context);  // Show error message if the request fails
    }

    _getTasksSummaryByStatusProgress = false;  // Hide progress indicator after the request completes
    setState(() {});
  }
} // ProgressTaskListScreen end
