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

/// Completed task list screen
class CompletedTaskListScreen extends StatefulWidget {
  static String name = 'completed-task-screen';

  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _isLoadingData = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? taskListModel;
  TaskModel? taskModel;

  /// Refreshes both the task count and task list
  Future<void> _refreshAllData() async {
    await _getCompletedTaskListView(isFromRefresh: true);
  }

  @override
  void initState() {
    super.initState();
    _getCompletedTaskListView(isFromRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AddNewTaskScreen.name);
          if (result == true) {
            // Rebuild the screen
            setState(() {
              _isLoadingData = true;
            });
            await _refreshAllData();
          }
        },
        child: const Icon(Icons.add),
      ),

      body:  _isLoadingData ?
      const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: _refreshAllData,
        child: taskListModel?.taskList?.isNotEmpty == true ?
        BackgroundScreen(
          child: Column(
            children: [
              _buildTaskListView(),
            ],
          ),
        )
            : BackgroundScreen(
          child: Stack(
            children: [
              ListView(),
              const Center(
                child: Text(
                  'Empty',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the task list view displaying each completed task
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
                color: const Color.fromRGBO(33, 191, 115, 1),
                taskModel: taskListModel?.taskList?[index],
                status: 'Completed',
                showEditButton: true,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Fetches the list of completed tasks
  Future<void> _getCompletedTaskListView({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _isLoadingData = true;
      setState(() {});
    }

    NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Completed'));

    if (networkResponse.isSuccess) {
      taskListModel = TaskListByStatusModel.fromJson(networkResponse.statusData!);
    } else {
      Mymessage(networkResponse.errorMessage, context);
    }
    _isLoadingData = false;
    setState(() {});
  }
}
