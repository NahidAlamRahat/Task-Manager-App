import 'package:flutter/material.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/canceled_task_list_screen.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/completed_task_list_screen.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/pending_task_list_screen.dart';

import 'new_task_list_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  static String name = '/home';

  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedteIndex = 0;
  final List<Widget> _screen = [
    NewTaskListScreen(),
    PendingTaskListScreen(),
    CompletedTaskListScreen(),
    CanceledTaskListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedteIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedteIndex,
          onDestinationSelected: (int index) {
           _selectedteIndex=index;
            setState(() {});
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
            NavigationDestination(icon: Icon(Icons.refresh), label: 'Pending'),
            NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
            NavigationDestination(icon: Icon(Icons.cancel), label: 'Cancel'),
          ]),
    );
  }
}
