import 'package:flutter/material.dart';
import 'package:tast_manager/ui/screen/add_new_task_screen.dart';
import 'package:tast_manager/widgets/TaskStatusSummaryCounterWidget.dart';
import 'package:tast_manager/widgets/background_screen.dart';
import 'package:tast_manager/widgets/task_item_widget.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: const Icon(Icons.add),
      ),
      body: BackgroundScreen(
        child: Column(
          children: [
            _buildTasksSummaryByStatus(),
            _buildTaskListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: 10,
          itemBuilder: (context, index) {
            return const TaskItemWidget();
          },
        ),
      ),
    );
  }

  Widget _buildTasksSummaryByStatus() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          TaskStatusSummaryCounterWidget(
            count: '09',
            title: 'new',
          ),
          TaskStatusSummaryCounterWidget(
            count: '12',
            title: 'pending',
          ),
          TaskStatusSummaryCounterWidget(
            count: '14',
            title: 'completed',
          ),
          TaskStatusSummaryCounterWidget(
            count: '15',
            title: 'cancel',
          ),
        ],
      ),
    );
  }
}

