import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tast_manager/ui/controllers/main_bottom_nav_controller.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/canceled_task_list_screen.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/completed_task_list_screen.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/progress_task_list_screen.dart';
import 'new_task_list_screen.dart';


class MainBottomNavScreen extends StatelessWidget {
  static String name = '/home';
  final int initialIndex;

  const MainBottomNavScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
final MainBottomNavController controller = Get.find<MainBottomNavController>();
    controller.selectedIndex = initialIndex;

    final List<Widget> screens = [
      const NewTaskListScreen(),
      const ProgressTaskListScreen(),
      const CompletedTaskListScreen(),
      const CanceledTaskListScreen()
    ];

    return Scaffold(
      body: GetBuilder<MainBottomNavController>(
        builder: (controller) => screens[controller.selectedIndex],
      ),
      bottomNavigationBar: GetBuilder<MainBottomNavController>(
        builder: (controller) => NavigationBar(
          selectedIndex: controller.selectedIndex,
          onDestinationSelected: (int index) {
            controller.changeIndex(index);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
            NavigationDestination(icon: Icon(Icons.refresh), label: 'Progress'),
            NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
            NavigationDestination(icon: Icon(Icons.cancel), label: 'Canceled'),
          ],
        ),
      ),
    );
  }
}

