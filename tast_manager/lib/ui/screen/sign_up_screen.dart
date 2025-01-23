import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tast_manager/data/services/network_caller.dart';
import 'package:tast_manager/data/utils/urls.dart';
import 'package:tast_manager/ui/screen/forget_pass_email_verification_screen.dart';
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
  // Controllers for text fields
  TextEditingController emailTEController = TextEditingController();
  TextEditingController passwordTEController = TextEditingController();
  TextEditingController firstNameTEController = TextEditingController();
  TextEditingController lastNameTEController = TextEditingController();
  TextEditingController mobileTEController = TextEditingController();

  // Global key for form validation
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // To manage the signup progress state
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
              key: formKey,  // Form for handling validation
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Join With Us',  // Title of the screen
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  // Email TextField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter an email.';  // Email validation
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
                  // First Name TextField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';  // First Name validation
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
                  // Last Name TextField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';  // Last Name validation
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
                  // Mobile Number TextField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number';  // Mobile validation
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
                  // Password TextField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a password';  // Password validation
                      }
                      if(value!.length < 6) {
                        return 'Enter a password more than 6 letters';  // Password length validation
                      }
                      return null;
                    },
                    controller: passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // SignUp Button with loading state
                  Visibility(
                    visible: singUpInProgress == false,  // If not in progress, show button
                    replacement: const Center(child: CircularProgressIndicator()),  // Show loading indicator if in progress
                    child: ElevatedButton(
                      onPressed: _onTapSingUpButton,  // SignUp button tap action
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Rich text for navigation to SignIn screen
                  Center(child: buildRichText())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // SignUp button tap handler
  void _onTapSingUpButton() {
    if (formKey.currentState!.validate()) {
      _singUp();  // Proceed with signup if validation passes
    }
  }

  // Function to handle the signup API request
  Future<void> _singUp() async {
    singUpInProgress = true;
    setState(() {});  // Update UI to show progress

    // Request body for signup API
    Map<String, dynamic> requestBody = {
      "email": emailTEController.text.trim(),
      "firstName": firstNameTEController.text.trim(),
      "lastName": lastNameTEController.text.trim(),
      "mobile": mobileTEController.text.trim(),
      "password": passwordTEController.text,
    };

    // Making the API call
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.registrationUrl, body: requestBody);

    singUpInProgress = false;
    setState(() {});  // Update UI after the request

    if(response.isSuccess) {
      Mymessage('${firstNameTEController.text} Your Registration Completed', context);
      const Duration(seconds: 2);  // Wait for 2 seconds before popping
      Navigator.pop(context);  // Navigate back to the previous screen
    } else {
      Mymessage('Something went wrong! Please try again', context);  // Error message if signup fails
    }
  } // _singUp End

  // Rich text for SignIn navigation
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
                  Navigator.pop(context);  // Navigate to SignIn screen
                }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    emailTEController.dispose();
    passwordTEController.dispose();
    firstNameTEController.dispose();
    lastNameTEController.dispose();
    mobileTEController.dispose();
    super.dispose();
  }
}
