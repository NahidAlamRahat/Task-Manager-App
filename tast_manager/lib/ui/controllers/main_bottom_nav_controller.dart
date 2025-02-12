import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainBottomNavController extends GetxController {
  int selectedIndex = 0;

  void changeIndex(int index) {
    selectedIndex = index;
    update();
  }
}