import 'package:get/get.dart';
import 'package:tast_manager/ui/controllers/sign_in_controller.dart';
import 'package:tast_manager/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SignInController(),);
    Get.lazyPut(() => UpdateProfileController());


  }

}
