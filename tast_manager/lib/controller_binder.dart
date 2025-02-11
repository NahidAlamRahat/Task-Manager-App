import 'package:get/get.dart';
import 'package:tast_manager/ui/controllers/add_new_task_controller.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/controllers/get_task_list_controller.dart';
import 'package:tast_manager/ui/controllers/new_task_list_controller.dart';
import 'package:tast_manager/ui/controllers/recover_reset_password_controller.dart';
import 'package:tast_manager/ui/controllers/sign_in_controller.dart';
import 'package:tast_manager/ui/controllers/sign_up_controller.dart';
import 'package:tast_manager/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings{

  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SignInController(),);
    Get.lazyPut(() => UpdateProfileController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => RecoverResetPasswordController());
    Get.lazyPut(() => AddNewTaskController());

    Get.put(NewTaskListController());
    Get.put(GetTaskListController());


  }

}
