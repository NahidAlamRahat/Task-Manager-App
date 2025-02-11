import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tast_manager/data/models/task_list_by_status_model.dart';
import 'package:tast_manager/data/models/user_data.dart';
import 'package:tast_manager/data/services/network_caller.dart';
import 'package:tast_manager/data/utils/urls.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/controllers/image_controller.dart';
import 'package:tast_manager/ui/controllers/update_profile_controller.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';
import '../../widgets/background_screen.dart';

class UpdateScreen extends StatefulWidget {
  static String name = 'update/screen';

  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();

  final UpdateProfileController _updateProfileController = Get.put( UpdateProfileController());
    ImageController imageController = ImageController();
    AuthController authController = Get.put(AuthController());
    AuthController _authController =AuthController();

  XFile? _imagePicker;
  TaskListByStatusModel? taskListModel;
  UserData? userData;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTEController.text =  authController.userModel.value?.email ?? 'empty';
    _firstNameTEController.text = authController.userModel.value?.firstName ?? 'empty';
    _lastNameTEController.text = authController.userModel.value?.lastName ?? 'empty';
    _mobileTEController.text = authController.userModel.value?.mobile ?? 'empty';

  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TaskManagerAppBar(
        textTheme: textTheme,
        fromUpdateProfile: true,
      ),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Update Profile',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoWidget(),
                  const SizedBox(height: 12),
                  TextFormField(
                    enabled: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter an email.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: _mobileTEController,
                    decoration: const InputDecoration(hintText: 'Mobile'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a password';
                      }
                      if (value!.length < 6) {
                        return 'Enter a password more than 6 letters';
                      }
                      return null;
                    },
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(height: 12),

                  GetBuilder<UpdateProfileController>(builder: (controller) {
                    return Visibility(
                      visible: controller.isLoadingDataProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                            _updateProfile();
                        },
                        child: const Text('Update Profile'),
                      ),
                    );
                  }),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoWidget() {
    return GestureDetector(
      onTap:() {
        getImagePicker();
        print('image=> $_imagePicker');
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _imagePicker == null ? 'No item selected' : _imagePicker!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
   }

  Future<void> getImagePicker() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imagePicker = image;
     setState(() {});
     // imageController.update();
    }
    print('image=> $image');
  }

 //  getImagePicker(){
 //    imageController.getImagePicker(imagePicker: imagePicker);
 // print('image=> $imagePicker');
 //  }
 //
 //
 //  getImagePicker({required XFile? image}){
 //    imageController.getImagePicker(imagePicker: image);
 //  print('image=> $image');
 //  }




  Future<void> _updateProfile() async {
    bool isSuccess = await _updateProfileController.updateProfile(

        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
        image: _imagePicker,
        password: _passwordTEController.text);

    if (isSuccess) {
      Mymessage(_updateProfileController.message, context);

    } else {
      Mymessage(_updateProfileController.message, context);
    }
  }


  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    super.dispose();
  }
}
