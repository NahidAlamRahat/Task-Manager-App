import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tast_manager/ui/screen/forget_pass_pin_verification_screen.dart';

import '../../utils/app_colors.dart';
import '../../widgets/background_screen.dart';

class ForgetPassEmailVerification extends StatefulWidget {
  static String name = 'forget/pass/email/verification';

  const ForgetPassEmailVerification({super.key});

  @override
  State<ForgetPassEmailVerification> createState() =>
      _ForgetPassEmailVerificationState();
}

class _ForgetPassEmailVerificationState
    extends State<ForgetPassEmailVerification> {
  TextEditingController emailTEController = TextEditingController();
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
                  'Your Email Address',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'A 6 digit verification OTP will sent to your email address',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter an email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pushNamed(
                          context, ForgetPassPinVerification.name);
                    }
                  },
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 6,
                ),
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
          style:  TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
                text: ' Sign in',
                style: TextStyle(
                  color: AppColors.themColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pop(context);
                  }),
          ]),
    );
  }

  @override
  void dispose() {
    emailTEController.dispose();
    super.dispose();
  }
}
