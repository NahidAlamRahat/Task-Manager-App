import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tast_manager/data/models/user_data.dart';
import 'package:tast_manager/data/services/network_caller.dart';
import 'package:tast_manager/data/utils/urls.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/main_bottom_nav_screen.dart';
import 'package:tast_manager/ui/screen/forget_pass_email_verification_screen.dart';
import 'package:tast_manager/ui/screen/sign_up_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';

import '../../utils/app_colors.dart';
import '../../widgets/background_screen.dart';

class SignInScreen extends StatefulWidget {
  static String name = 'sing-in-screen';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

bool _signInInProgress = false;

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailTEController = TextEditingController();
  TextEditingController passwordTEController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Get Started With',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your email';
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
                            return 'Enter your password';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: passwordTEController,
                        decoration: const InputDecoration(hintText: 'Password'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Visibility(
                  visible: _signInInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ///code here
                        setState(() {
                          logInRequest();
                        });
                      }
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ForgetPassEmailVerification.name);
                        },
                        child: const Text('Forget password'),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      buildRichText(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRichText() {
    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style: TextStyle(
          color: AppColors.blackColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: ' Sign up',
            style: TextStyle(
              color: AppColors.themColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, SignUpScreen.name);
              },
          ),
        ],
      ),
    );
  }

  Future<void> logInRequest() async {
    _signInInProgress = true;
    setState(() {});
    Map<String, dynamic> logInBody = {
      "email": emailTEController.text.trim(),
      "password": passwordTEController.text,
    };

    final NetworkResponse response =
        await NetworkCaller.postRequest(url: Urls.loginUrl, body: logInBody);
    if (response.isSuccess) {
      _signInInProgress = false;
      ///use Shared_Preferences
      String token = response.statusData!['token'];
      UserData userData = UserData.fromJson(response.statusData!['data']);
      await AuthController.saveData(token, userData);
      setState(() {});

      Mymessage('LogIn Success', context);
      Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
    } else {
      _signInInProgress = false;
      debugPrint('Status Code = ${response.statusCode}');
      debugPrint('${response.statusData}');
      Mymessage('something error', context);
    }
  } //logInRequest end

  @override
  void dispose() {
    emailTEController.dispose();
    passwordTEController.dispose();
    super.dispose();
  }
}
