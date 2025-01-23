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

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _getTasksSummaryByStatusProgress = false;  // Keeps track of the loading state for task summary

  TaskCountByStatusModel? taskCountByStatusModel;  // Holds the count of tasks by different statuses
  TaskListByStatusModel? taskListModel;  // Holds the list of tasks filtered by status
  TaskModel? taskModel;  // Single task model, used in some tasks

  /// This method refreshes both task count summary and the task list
  Future<void> _refreshAllData() async {
    // Fetches updated task count and completed tasks when user refreshes the page
    await _getTaskCountByStatus(isFromRefresh: true);
    await _getCompletedTaskListView(isFromRefresh: true);
  }

  @override
  void initState() {
    super.initState();
    // Initially fetches task count and completed task list
    _getTaskCountByStatus(isFromRefresh: false);
    _getCompletedTaskListView(isFromRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;  // Get current text style from the theme

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme),  // Custom app bar for the task manager screen
      floatingActionButton: FloatingActionButton(
        // Button to navigate to the screen where new tasks can be added
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: const Icon(Icons.add),  // Add icon on the button
      ),
      body: RefreshIndicator(
        // Pull-to-refresh functionality
        onRefresh: _refreshAllData,
        child: BackgroundScreen(
          child: Column(
            children: [
              SizedBox(
                height: 100,  // Height of the task summary section
                child: _buildTasksSummaryByStatus(),  // Displays the task summary
              ),
              _buildTaskListView(),  // Displays the list of completed tasks
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the task list view, displaying each task as an item in the list
  Widget _buildTaskListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),  // Ensures scrolling is always enabled
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: taskListModel?.taskList?.length ?? 0,  // List item count
            itemBuilder: (context, index) {
              // Each task is represented as a TaskItemWidget
              return TaskItemWidget(
                color: const Color.fromRGBO(33, 191, 115, 1),  // Custom color for completed tasks
                taskModel: taskListModel?.taskList?[index],  // Passing each task model to the widget
                status: 'Completed',  // Task status is marked as "Completed"
                showEditButton: true,  // Display an edit button for each task
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the horizontal summary of tasks by their statuses
  Widget _buildTasksSummaryByStatus() {
    return Visibility(
      visible: _getTasksSummaryByStatusProgress == false,  // Only show summary when not loading
      replacement: const Center(child: CircularProgressIndicator()),  // Show loading indicator when fetching
      child: SizedBox(
        height: 100,  // Fixed height for the summary section
        child: ListView.builder(
          scrollDirection: Axis.horizontal,  // Display the summary horizontally
          itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
          itemBuilder: (context, index) {
            // Display task count for each task status
            final TaskCountModel model = taskCountByStatusModel!.taskByStatusList![index];
            return TaskStatusSummaryCounterWidget(
              count: model.sum.toString(),  // Task count in the summary
              title: model.sId ?? '',  // Task status title
            );
          },
        ),
      ),
    );
  }

  /// Fetches the count of tasks grouped by their statuses
  Future<void> _getTaskCountByStatus({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _getTasksSummaryByStatusProgress = true;  // Show loading indicator when data is being fetched
      setState(() {});
    }

    // Network request to get task status count data
    NetworkResponse networkResponse = await NetworkCaller.getRequest(url: Urls.taskStatusCountUrl);

    if (networkResponse.isSuccess) {
      taskCountByStatusModel = TaskCountByStatusModel.fromJson(networkResponse.statusData!);
    } else {
      Mymessage(networkResponse.errorMessage, context);  // Show error message if request fails
    }
    _getTasksSummaryByStatusProgress = false;  // Hide loading indicator once data is fetched
    setState(() {});
  }

  /// Fetches the list of completed tasks
  Future<void> _getCompletedTaskListView({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _getTasksSummaryByStatusProgress = true;  // Show loading indicator when data is being fetched
      setState(() {});
    }

    // Network request to get the list of completed tasks
    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('Completed'));

    if (networkResponse.isSuccess) {
      taskListModel = TaskListByStatusModel.fromJson(networkResponse.statusData!);
    } else {
      Mymessage(networkResponse.errorMessage, context);  // Show error message if request fails
    }
    _getTasksSummaryByStatusProgress = false;  // Hide loading indicator once data is fetched
    setState(() {});
  }
}
