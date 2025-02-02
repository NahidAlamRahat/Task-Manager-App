import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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

class NewTaskListScreen extends StatefulWidget {
  static String name = 'new-task-screen';

  const NewTaskListScreen({super.key,

  });

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _isLoadingDataProgress = false;

  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? taskListModel;

  /// Refresh both task count and task list
  Future<void> _refreshAllData() async {
    await _getTaskCountByStatus(isFromRefresh: true);
    await getNewTaskList(isFromRefresh: true);
  }

  @override
  void initState() {
    super.initState();
    _isLoadingDataProgress = true;
    _getTaskCountByStatus(isFromRefresh: false);
    getNewTaskList(isFromRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(

      appBar: TaskManagerAppBar(textTheme: textTheme),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {
         final result = await Get.toNamed(AddNewTaskScreen.name);
          if (result == true) {
            // Rebuild the screen
              _isLoadingDataProgress = true;
              setState(() {});
          }
          _refreshAllData();
        },
        child: const Icon(Icons.add),
      ),

      body: _isLoadingDataProgress ?
      const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: _refreshAllData,
        child: taskListModel?.taskList?.isNotEmpty == true ?
        BackgroundScreen(
          child: Column(
            children: [
              SizedBox(height: 100, child: _buildTasksSummaryByStatus()),
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

  /// Builds the list view of new tasks
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
                color: Colors.blue,
                taskModel: taskListModel?.taskList?[index],
                status: 'New',
                showEditButton: true,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the summary of tasks by status
  Widget _buildTasksSummaryByStatus() {
    return Visibility(
      visible: _isLoadingDataProgress == false,
      replacement: const Center(child: CircularProgressIndicator()),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
          itemBuilder: (context, index) {
            final TaskCountModel model =
            taskCountByStatusModel!.taskByStatusList![index];
            return TaskStatusSummaryCounterWidget(
              count: model.sum.toString(),
              title: model.sId ?? 'empty',
            );
          },
        ),
      ),
    );
  }

  /// Fetch task count summary by status from the network
  Future<void> _getTaskCountByStatus({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _isLoadingDataProgress = true;
      setState(() {});
    }

    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(url: Urls.taskStatusCountUrl);

    if (networkResponse.isSuccess) {
      taskCountByStatusModel =
          TaskCountByStatusModel.fromJson(networkResponse.statusData!);
    } else {
      Mymessage(networkResponse.errorMessage, context);
    }

    _isLoadingDataProgress = false;
    setState(() {});
  }

  /// Fetches the new task list from the network
  Future<void> getNewTaskList({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _isLoadingDataProgress = true;
      setState(() {});
    }

    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('New'));

    if (networkResponse.isSuccess) {
      taskListModel =
          TaskListByStatusModel.fromJson(networkResponse.statusData!);
    } else {
      Mymessage(networkResponse.errorMessage, context);
    }

    _isLoadingDataProgress = false;
    setState(() {});
  }




}

