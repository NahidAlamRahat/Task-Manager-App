import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'A 6 digit verification OTP will be sent to your email address',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter an email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _emailVerification();
                    }
                  },
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 6),
                Center(child: buildRichText())
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
      text: "Have an account? ",
      style: TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w600),
      children: [
      TextSpan(
      text: ' Sign in',
      style: TextStyle(color: AppColors.themColor),
      recognizer: TapGestureRecognizer()..onTap = () {
       Navigator.pop(context);
     }),
     ]),
    );
  }

  Future<void> _emailVerification() async {
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyEmailUrl(_emailTEController.text.trim()));

    if (networkResponse.isSuccess) {
      Mymessage('Check your email', context);
      Get.toNamed( ForgetPassPinVerification.name,
          arguments: _emailTEController.text.trim());
    } else {
      Mymessage(networkResponse.errorMessage, context);
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
