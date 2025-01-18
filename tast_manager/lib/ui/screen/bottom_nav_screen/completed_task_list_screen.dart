import 'package:flutter/material.dart';
import 'package:tast_manager/widgets/background_screen.dart';
import 'package:tast_manager/widgets/task_item_widget.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme),
      body: BackgroundScreen(
        child: Column(
          children: [
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
          itemCount: 8,
          itemBuilder: (context, index) {
            return const TaskItemWidget();
          },
        ),
      ),
    );
  }

}

