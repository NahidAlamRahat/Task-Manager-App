import 'package:flutter/material.dart';
import 'package:tast_manager/data/models/task_count_by_status_model.dart';
import 'package:tast_manager/data/models/task_count_model.dart';
import 'package:tast_manager/data/services/network_caller.dart';
import 'package:tast_manager/data/utils/urls.dart';
import 'package:tast_manager/ui/screen/add_new_task_screen.dart';
import 'package:tast_manager/widgets/TaskStatusSummaryCounterWidget.dart';
import 'package:tast_manager/widgets/background_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';
import 'package:tast_manager/widgets/task_item_widget.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';
import '../../../data/models/task_list_by_status_model.dart';

// Canceled task list screen
class CanceledTaskListScreen extends StatefulWidget {
  const CanceledTaskListScreen({super.key});

  @override
  State<CanceledTaskListScreen> createState() => _CanceledTaskListScreenState();
}

class _CanceledTaskListScreenState extends State<CanceledTaskListScreen> {
  bool _getTasksSummaryByStatusProgress = false;

  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? taskListModel;

  // Refresh both task count and task list
  Future<void> _refreshAllData() async {
    await _getTaskCountByStatus(isFromRefresh: true); // Refresh task count
    await _getCanceledTaskListView(isFromRefresh: true); // Refresh canceled task list
  }

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus(isFromRefresh: false); // Load task count initially
    _getCanceledTaskListView(isFromRefresh: false); // Load canceled tasks initially
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme), // App bar with custom theme
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name); // Navigate to Add New Task screen
        },
        child: const Icon(Icons.add), // Icon to add a new task
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAllData, // Enable pull-to-refresh functionality
        child: BackgroundScreen(
          child: Column(
            children: [
              SizedBox(height: 100, child: _buildTasksSummaryByStatus()), // Task summary by status
              _buildTaskListView(), // Canceled task list
            ],
          ),
        ),
      ),
    );
  }

  // Builds the list view of canceled tasks
  Widget _buildTaskListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: taskListModel?.taskList?.length ?? 0,
            itemBuilder: (context, index) {
              return TaskItemWidget(
                color: const Color.fromRGBO(241, 80, 86, 1.0), // Red color for canceled tasks
                taskModel: taskListModel?.taskList?[index], // Task data
                status: 'Canceled', // Status label
                showEditButton: false, // No edit button for canceled tasks
              );
            },
          ),
        ),
      ),
    );
  }

  // Builds the summary of tasks by status (e.g., Canceled, Pending, etc.)
  Widget _buildTasksSummaryByStatus() {
    return Visibility(
      visible: _getTasksSummaryByStatusProgress == false, // Show only when not loading
      replacement: const Center(
        child: CircularProgressIndicator(), // Show loading indicator while fetching data
      ),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Horizontal scroll for status summary
          itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
          itemBuilder: (context, index) {
            final TaskCountModel model =
            taskCountByStatusModel!.taskByStatusList![index];
            return TaskStatusSummaryCounterWidget(
              count: model.sum.toString(), // Display task count
              title: model.sId ?? '', // Display task status name
            );
          },
        ),
      ),
    );
  }

  // Fetch task count summary by status
  Future<void> _getTaskCountByStatus({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _getTasksSummaryByStatusProgress = true; // Start loading
      setState(() {});
    }

    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(url: Urls.taskStatusCountUrl); // Fetch task count

    if (networkResponse.isSuccess) {
      taskCountByStatusModel =
          TaskCountByStatusModel.fromJson(networkResponse.statusData!); // Parse data
    } else {
      Mymessage(networkResponse.errorMessage, context); // Show error message
    }
    _getTasksSummaryByStatusProgress = false; // Stop loading
    setState(() {});
  }

  // Fetch the list of canceled tasks
  Future<void> _getCanceledTaskListView({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _getTasksSummaryByStatusProgress = true; // Start loading
      setState(() {});
    }

    NetworkResponse networkResponse = await NetworkCaller.getRequest(
      url: Urls.taskListByStatusUrl('Canceled'), // URL for canceled tasks
    );

    if (networkResponse.isSuccess) {
      taskListModel =
          TaskListByStatusModel.fromJson(networkResponse.statusData!); // Parse task list
    } else {
      Mymessage(networkResponse.errorMessage, context); // Show error message
    }
    _getTasksSummaryByStatusProgress = false; // Stop loading
    setState(() {});
  }
}
