import 'package:flutter/material.dart';

class TaskStatusSummaryCounterWidget extends StatelessWidget {
  const TaskStatusSummaryCounterWidget({
    super.key,
    required this.count,
    required this.title,
  });

  final String count;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        child: Column(
          children: [
            Text(
              count,
              style: textTheme.titleLarge?.copyWith(
              ),
            ),
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                color: Colors.grey
              ),
            ),
          ],
        ),
      ),
    );
  }
}
