import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tast_manager/data/models/task_count_by_status_model.dart';
import 'package:tast_manager/data/services/network_caller.dart';
import 'package:tast_manager/data/utils/urls.dart';
import 'package:tast_manager/ui/screen/add_new_task_screen.dart';
import 'package:tast_manager/widgets/background_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';
import 'package:tast_manager/widgets/task_item_widget.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';
import '../../../data/models/task_list_by_status_model.dart';

/// Canceled task list screen
class CanceledTaskListScreen extends StatefulWidget {
  static String name = 'canceled-task-screen';

  const CanceledTaskListScreen({super.key});

  @override
  State<CanceledTaskListScreen> createState() => _CanceledTaskListScreenState();
}

class _CanceledTaskListScreenState extends State<CanceledTaskListScreen> {
  bool _isLoadingData = false;

  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? taskListModel;

  /// Refresh both task count and task list
  Future<void> _refreshAllData() async {
    await _getCanceledTaskListView(isFromRefresh: true);
  }

  @override
  void initState() {
    super.initState();
    _getCanceledTaskListView(isFromRefresh: false);
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
            setState(() {
              _isLoadingData = true;
            });
            await _refreshAllData();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: _isLoadingData ?
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

  /// Builds the list view of canceled tasks
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
                color: const Color.fromRGBO(241, 80, 86, 1.0),
                taskModel: taskListModel?.taskList?[index],
                status: 'Canceled',
                showEditButton: false,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Fetch the list of canceled tasks
  Future<void> _getCanceledTaskListView({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _isLoadingData = true;
      setState(() {});
    }

    NetworkResponse networkResponse = await NetworkCaller.getRequest(
      url: Urls.taskListByStatusUrl('Canceled'),
    );

    if (networkResponse.isSuccess) {
      taskListModel =
          TaskListByStatusModel.fromJson(networkResponse.statusData!);
    } else {
      Mymessage(networkResponse.errorMessage, context);
    }
    _isLoadingData = false;
    setState(() {});
  }
}
