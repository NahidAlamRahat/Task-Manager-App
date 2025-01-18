import 'package:flutter/material.dart';
import 'package:tast_manager/widgets/background_screen.dart';
import 'package:tast_manager/widgets/task_item_widget.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';

class CanceledTaskListScreen extends StatefulWidget {
  const CanceledTaskListScreen({super.key});

  @override
  State<CanceledTaskListScreen> createState() => _CanceledTaskListScreenState();
}

class _CanceledTaskListScreenState extends State<CanceledTaskListScreen> {
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
          itemCount: 4,
          itemBuilder: (context, index) {
            return const TaskItemWidget();
          },
        ),
      ),
    );
  }

}

