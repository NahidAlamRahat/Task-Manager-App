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

bool _signInProgress = false;

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
                // Form for user login input (email and password)
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Email text input field with validation
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
                      // Password text input field with validation and hiding text
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
                const SizedBox(height: 12),
                // Login button with conditional visibility for progress indicator
                Visibility(
                  visible: _signInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // If the form is valid, initiate the login request
                      if (formKey.currentState!.validate()) {
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
                // Forgot password and sign-up navigation
                Center(
                  child: Column(
                    children: [
                      // Button for forgot password navigation
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
                      // Rich text with clickable sign-up link
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

  // Method for building a rich text with "Don't have an account?" and sign-up link
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
                // Navigate to Sign-Up screen when tapped
                Navigator.pushNamed(context, SignUpScreen.name);
              },
          ),
        ],
      ),
    );
  }

  // Method for sending the login request to the server
  Future<void> logInRequest() async {
    // Set sign-in progress to true
    _signInProgress = true;
    setState(() {});

    // Prepare the login data to be sent in the request body
    Map<String, dynamic> requestLogInBody = {
      "email": emailTEController.text.trim(),
      "password": passwordTEController.text,
    };

    // Make the API request for login
    final NetworkResponse response =
    await NetworkCaller.postRequest(url: Urls.loginUrl, body: requestLogInBody);

    // Set sign-in progress to false once the request is complete
    _signInProgress = false;
    setState(() {});

    debugPrint('Response Status: ${response.isSuccess}');
    debugPrint('Response Data: ${response.statusData}');

    // If login is successful, handle the response
    if (response.isSuccess) {
      // If the response data is a string, attempt to parse it
      if (response.statusData is String) {
        try {
          response.statusData = jsonDecode(response.statusData as String);
        } catch (e) {
          debugPrint('Failed to parse response: $e');
          Mymessage('Unexpected response from server.', context);
          return;
        }
      }

      // Extract token and user data from the response
      String? token = response.statusData?['token'];
      UserData? userData = UserData.fromJson(response.statusData?['data'] ?? {});

      // If the token is available, save the token and user data, then navigate
      if (token != null) {
        await AuthController.saveData(token, userData);
        Mymessage('LogIn Success', context);
        Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
      } else {
        Mymessage('Token missing in response.', context);
      }
    }
    // If login fails due to invalid credentials (401 status code)
    else if (response.statusCode == 401) {
      Mymessage('Email/Password Invalid. Please try again!', context);
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Error Data: ${response.statusData}');
    }
    // Handle any other errors
    else {
      Mymessage('An error occurred. Please try again later.', context);
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Error Data: ${response.statusData}');
    }
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    emailTEController.dispose();
    passwordTEController.dispose();
    super.dispose();
  }
}
