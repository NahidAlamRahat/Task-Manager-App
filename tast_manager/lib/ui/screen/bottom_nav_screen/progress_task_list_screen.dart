import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tast_manager/ui/screen/add_new_task_screen.dart';
import 'package:tast_manager/widgets/background_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';
import 'dart:async';
import 'package:tast_manager/ui/controllers/get_task_list_controller.dart';
import 'package:tast_manager/widgets/build_task_List_view.dart';


class ProgressTaskListScreen extends StatefulWidget {
  static String name = 'progress-task-screen';

  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  final GetTaskListController _getTaskListController = Get.find<GetTaskListController>();

  @override
  void initState() {
    super.initState();
    _getProgressTaskListView(isFromRefresh: false);
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
            await _refreshAllData();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: GetBuilder<GetTaskListController>(
          builder: (controller) {
            if (controller.isLoadingDataProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Jodi task list khali thake
            if (controller.taskListModel.isEmpty) {
              return BackgroundScreen(
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
              );
            }

            // Task list show korar jonno
            return BackgroundScreen(
              child: Column(
                children: [
                  BuildTaskListView.buildTaskListView(
                      taskList: controller.taskListModel,
                      status: 'Progress',
                      color: const Color.fromRGBO(203, 12, 159, 1)
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _refreshAllData() async {
    await _getProgressTaskListView(isFromRefresh: true);
    _getTaskListController.update();
  }

  Future<void> _getProgressTaskListView({bool isFromRefresh = false}) async {
    bool completedTaskListIsSuccess = await _getTaskListController.getTaskList(
      isFromRefresh: isFromRefresh,
      statusName: 'Progress');

    if (!completedTaskListIsSuccess) {
      Mymessage(_getTaskListController.message, context);
    }
    _getTaskListController.update();
  }

}


