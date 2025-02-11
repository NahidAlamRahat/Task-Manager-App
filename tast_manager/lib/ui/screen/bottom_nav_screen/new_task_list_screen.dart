import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tast_manager/data/models/task_count_model.dart';
import 'package:tast_manager/ui/controllers/new_task_list_controller.dart';
import 'package:tast_manager/ui/screen/add_new_task_screen.dart';
import 'package:tast_manager/widgets/TaskStatusSummaryCounterWidget.dart';
import 'package:tast_manager/widgets/background_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';
import '../../../widgets/build_task_List_view.dart';

class NewTaskListScreen extends StatefulWidget {
  static String name = 'new-task-screen';

  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  final NewTaskListController _newTaskListController = Get.find<NewTaskListController>();

  /// Refresh both task count and task list
  Future<void> _refreshAllData() async {
    _newTaskListController.isLoading.value = true; // Set loading true
    await _getTaskCountByStatus(isFromRefresh: true);
    await _getNewTaskList(isFromRefresh: true);
    _newTaskListController.isAppBarRebuilt.value = true;
  }

  @override
  void initState() {
    super.initState();
// Execute code after the initial widget tree has been built and displayed
     WidgetsBinding.instance.addPostFrameCallback((_) {
      _newTaskListController.isLoading.value = true;
      _getTaskCountByStatus(isFromRefresh: false);
      _getNewTaskList(isFromRefresh: false);
    });
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AddNewTaskScreen.name);
          if (result == true) {
            _newTaskListController.isLoading.value = true; // Set loading true
          }
          _refreshAllData();
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        return _newTaskListController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _refreshAllData,
          child: _newTaskListController.taskListModel.isNotEmpty
              ? BackgroundScreen(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: _buildTasksSummaryByStatus(
                      taskCountModel: _newTaskListController.taskCountModel),
                ),
                BuildTaskListView.buildTaskListView(
                    taskList: _newTaskListController.taskListModel,
                    status: 'New',
                ),
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
        );
      }),
    );
  }

  /// Builds the summary of tasks by status
  Widget _buildTasksSummaryByStatus({required List<TaskCountModel> taskCountModel}) {
    return Visibility(
      visible: _newTaskListController.isLoading.value == false,
      replacement: const Center(child: CircularProgressIndicator()),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: taskCountModel.length,
          itemBuilder: (context, index) {
            final TaskCountModel model = taskCountModel[index];
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
    bool isSuccess = await _newTaskListController.getTaskCountByStatus(isFromRefresh: isFromRefresh);
    if (!isSuccess) {
      Mymessage('error', context);
    }
    _newTaskListController.isLoading.value = false; // Set loading false
  }

  /// Fetches the new task list from the network
  Future<void> _getNewTaskList({bool isFromRefresh = false}) async {
    bool isSuccess = await _newTaskListController.getTaskList(
        isFromRefresh: isFromRefresh, statusName: 'New');
    if (!isSuccess) {
      Mymessage('error', context);
    }
    _newTaskListController.isLoading.value = false; // Set loading false
  }

}
