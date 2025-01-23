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

/// Screen displaying the list of new tasks with a summary of tasks by status.
class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTasksSummaryByStatusProgress = false;  // Flag to manage loading state

  TaskCountByStatusModel? taskCountByStatusModel;  // Model for task count by status
  TaskListByStatusModel? taskListModel;  // Model for task list by status
  TaskModel? taskModel;  // Placeholder for individual task model

  /// Refresh both task count and list
  Future<void> _refreshAllData() async {
    await _getTaskCountByStatus(isFromRefresh: true);  // Refresh task count by status
    await _getNewTaskListView(isFromRefresh: true);  // Refresh new task list view
  }

  @override
  void initState() {
    super.initState();
    // Initial API calls to get task count by status and new task list view
    _getTaskCountByStatus(isFromRefresh: false);
    _getNewTaskListView(isFromRefresh: false);
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
        child: const Icon(Icons.add),  // Add button icon
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAllData,  // Enables pull-to-refresh functionality
        child: BackgroundScreen(
          child: Column(
            children: [
              SizedBox(
                  height: 100,
                  child: _buildTasksSummaryByStatus()),  // Display task summary by status
              _buildTaskListView(),  // Display the list of tasks
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the task list view displaying each task item.
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
                color: Colors.blue,  // Custom color for task item widget
                taskModel: taskListModel?.taskList?[index],  // Pass the individual task model
                status: 'New',  // Status of task
                showEditButton: true,  // Show the edit button
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
      visible: _getTasksSummaryByStatusProgress == false,  // Shows summary only when data is ready
      replacement: const Center(child: CircularProgressIndicator()),  // Shows progress indicator while loading
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,  // Horizontal scrolling for task status counters
          itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,  // Safely access the task count list
          itemBuilder: (context, index) {
            final TaskCountModel model = taskCountByStatusModel!.taskByStatusList![index];
            return TaskStatusSummaryCounterWidget(
              count: model.sum.toString(),
              title: model.sId ?? 'empty',  // Displays task status and count
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
      Mymessage(networkResponse.errorMessage, context);  // Show error message if request fails
    }

    _getTasksSummaryByStatusProgress = false;  // Hide progress indicator
    setState(() {});
  }

  /// Fetches the new task list view from the network and updates the state.
  Future<void> _getNewTaskListView({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _getTasksSummaryByStatusProgress = true;  // Show progress indicator while fetching data
      setState(() {});
    }

    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('New'));

    if (networkResponse.isSuccess) {
      taskListModel = TaskListByStatusModel.fromJson(networkResponse.statusData!);
    } else {
      Mymessage(networkResponse.errorMessage, context);  // Show error message if request fails
    }

    _getTasksSummaryByStatusProgress = false;  // Hide progress indicator
    setState(() {});
  }
} // NewTaskListScreen end