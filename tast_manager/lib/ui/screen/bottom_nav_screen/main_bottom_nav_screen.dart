import 'package:flutter/material.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/canceled_task_list_screen.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/completed_task_list_screen.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/progress_task_list_screen.dart';
import 'new_task_list_screen.dart';

/// Main screen that displays a bottom navigation bar to switch between different task lists.
class MainBottomNavScreen extends StatefulWidget {
  static String name = '/home';  // Route name for navigation

  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;  // Tracks the selected index of the bottom navigation
  final List<Widget> _screen = [
    NewTaskListScreen(),  // Screen for new tasks
    ProgressTaskListScreen(),  // Screen for tasks in progress
    CompletedTaskListScreen(),  // Screen for completed tasks
    CanceledTaskListScreen()  // Screen for canceled tasks
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Displays the selected screen based on the index
      body: _screen[_selectedIndex],

      /// Bottom navigation bar that allows the user to switch between different task list screens.
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,  // Shows the current selected index
          onDestinationSelected: (int index) {
            // Updates the selected index and triggers a rebuild of the widget
            _selectedIndex = index;
            setState(() {});
          },
          destinations: const [
            /// Navigation destination for the "New" task list screen
            NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),

            /// Navigation destination for the "Progress" task list screen
            NavigationDestination(icon: Icon(Icons.refresh), label: 'Progress'),

            /// Navigation destination for the "Completed" task list screen
            NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),

            /// Navigation destination for the "Canceled" task list screen
            NavigationDestination(icon: Icon(Icons.cancel), label: 'Canceled'),
          ]),
    );
  }
}
