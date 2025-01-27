import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tast_manager/data/services/network_caller.dart';
import 'package:tast_manager/data/utils/urls.dart';
import 'package:tast_manager/ui/screen/forget_pass_email_verification_screen.dart';
import 'package:tast_manager/ui/screen/update_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';

import '../../utils/app_colors.dart';
import '../../widgets/background_screen.dart';

class SignUpScreen extends StatefulWidget {
  static String name = 'sing-up-screen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailTEController = TextEditingController();
  TextEditingController passwordTEController = TextEditingController();
  TextEditingController firstNameTEController = TextEditingController();
  TextEditingController lastNameTEController = TextEditingController();
  TextEditingController mobileTEController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  XFile? _imagePicker;
  bool singUpInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                    'Join With Us',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoWidget(),
                  SizedBox(height: 12,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter an email.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailTEController,
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
                    controller: firstNameTEController,
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
                    controller: lastNameTEController,
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
                    controller: mobileTEController,
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
                    controller: passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Visibility(
                    visible: singUpInProgress == false,
                    replacement:
                        const Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: _onTapSingUpButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(child: buildRichText())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSingUpButton() {
    if (formKey.currentState!.validate()) {
      _singUp();
    }
  }

  Widget _buildPhotoWidget() {
    return GestureDetector(
      onTap: _getImagePicker,
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

  Future<void> _getImagePicker() async {
    final ImagePicker picker = ImagePicker();
    XFile? image= await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imagePicker = image;
      setState(() {});
    }
  }

  Future<void> _singUp() async {
    singUpInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": emailTEController.text.trim(),
      "firstName": firstNameTEController.text.trim(),
      "lastName": lastNameTEController.text.trim(),
      "mobile": mobileTEController.text.trim(),
      "password": passwordTEController.text,
    };
    if(_imagePicker != null){
      List<int> imageBytes = await _imagePicker!.readAsBytes();
      requestBody["photo"]= base64Encode(imageBytes);
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.registrationUrl, body: requestBody);

    singUpInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      Mymessage(
          '${firstNameTEController.text} Your Registration Completed', context);
      const Duration(seconds: 2);
      Navigator.pop(context);
    } else {
      Mymessage('Something went wrong! Please try again', context);
    }
  }

  Widget buildRichText() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: TextStyle(
          color: AppColors.blackColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
              text: 'Sign in',
              style: TextStyle(
                color: AppColors.themColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailTEController.dispose();
    passwordTEController.dispose();
    firstNameTEController.dispose();
    lastNameTEController.dispose();
    mobileTEController.dispose();
    super.dispose();
  }
}
