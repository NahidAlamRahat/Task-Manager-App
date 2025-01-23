import 'package:flutter/material.dart';

class TaskStatusSummaryCounterWidget extends StatelessWidget {
  const TaskStatusSummaryCounterWidget({
    super.key,
    required this.count,  // Task count to display
    required this.title,  // Title to describe the count (e.g., 'Completed', 'Pending')
  });

  final String count;  // The number representing the count (e.g., number of tasks)
  final String title;  // Title to describe what the count represents (e.g., task category)

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;  // Get the text theme from the current context
    return Card(
      elevation: 0,  // Set elevation of the card to 0 (flat card)
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),  // Set padding inside the card
        child: Column(
          children: [
            Text(
              count,  // Display the task count
              style: textTheme.titleLarge?.copyWith(
                // Customize the style of the count (no specific changes made)
              ),
            ),
            Text(
              title,  // Display the title (e.g., 'Completed', 'Pending')
              style: textTheme.titleSmall?.copyWith(
                  color: Colors.grey  // Set the title color to grey
              ),
            ),
          ],
        ),
      ),
    );
  }
}
