import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tast_manager/ui/screen/forget_pass_pin_verification_screen.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../../utils/app_colors.dart';
import '../../widgets/background_screen.dart';
import '../../widgets/show_snackber_message.dart';

class ForgetPassEmailVerification extends StatefulWidget {
  static String name = 'forget/pass/email/verification';

  const ForgetPassEmailVerification({super.key});

  @override
  State<ForgetPassEmailVerification> createState() =>
      _ForgetPassEmailVerificationState();
}

class _ForgetPassEmailVerificationState
    extends State<ForgetPassEmailVerification> {
  final TextEditingController _emailTEController = TextEditingController(); // Controller for the email field
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key for the form

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
                  'Your Email Address',
                  style: textTheme.titleLarge, // Title of the screen
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'A 6 digit verification OTP will be sent to your email address',
                  style: textTheme.titleMedium, // Info text for OTP
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey, // Attach form validation key
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction, // Auto-validate on user interaction
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter an email'; // Email validation
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress, // Set keyboard to email type
                    controller: _emailTEController, // Attach controller to field
                    decoration: const InputDecoration(hintText: 'Email'), // Decoration for the email field
                  ),
                ),
                const SizedBox(height: 12,),

                // Email verification button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      /// Call email verification function
                      _emailVerification();
                    }
                  },
                  child: const Icon(Icons.arrow_circle_right_outlined), // Button icon
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 6),

                // Rich text for navigation to sign-in
                Center(child: buildRichText())
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to create a rich text with a link for users to navigate to sign-in
  Widget buildRichText() {
    return RichText(
      text: TextSpan(
          text: "Have an account? ",
          style:  TextStyle(
            color: AppColors.blackColor, // Text color for the statement
            fontWeight: FontWeight.w600, // Text weight for emphasis
          ),
          children: [
            // "Sign in" link
            TextSpan(
                text: ' Sign in',
                style: TextStyle(
                  color: AppColors.themColor, // Color for the link
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pop(context); // Navigate back to previous screen
                  }),
          ]),
    );
  }

  /// Function to handle email verification
  Future<void> _emailVerification() async {
    // Sending GET request to verify email
    NetworkResponse networkResponse =
    await NetworkCaller.getRequest(url: Urls.recoverVerifyEmailUrl(_emailTEController.text));

    // Handle the server response
    if (networkResponse.isSuccess) {
      Mymessage('Check your email', context); // Show success message
      // Navigate to pin verification screen with email argument
      Navigator.pushNamed(
          context,
          ForgetPassPinVerification.name,
          arguments: _emailTEController.text.trim());
    } else {
      Mymessage(networkResponse.errorMessage, context); // Show error message if failed
    }
  }

  // Dispose method to clean up the controller when the screen is removed
  @override
  void dispose() {
    _emailTEController.dispose(); // Dispose the email controller
    super.dispose(); // Call dispose on the superclass
  }
}
