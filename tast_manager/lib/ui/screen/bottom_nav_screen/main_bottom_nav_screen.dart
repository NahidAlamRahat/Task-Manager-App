import 'package:flutter/material.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/canceled_task_list_screen.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/completed_task_list_screen.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/progress_task_list_screen.dart';
import 'new_task_list_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  static String name = '/home';

  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screen = [
    const NewTaskListScreen(),
    const ProgressTaskListScreen(),
    const CompletedTaskListScreen(),
    const CanceledTaskListScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            _selectedIndex = index;
            setState(() {});
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
            NavigationDestination(icon: Icon(Icons.refresh), label: 'Progress'),
            NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
            NavigationDestination(icon: Icon(Icons.cancel), label: 'Canceled'),
          ]),
    );
  }
}
