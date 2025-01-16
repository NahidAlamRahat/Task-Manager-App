import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tast_manager/ui/screen/forget_pass_pin_verification_screen.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';

import '../../utils/app_colors.dart';
import '../../widgets/background_screen.dart';

class ForgetPassResetPasswordScreen extends StatefulWidget {
  static String name = 'forget/pass/reset/password';

  const ForgetPassResetPasswordScreen({super.key});

  @override
  State<ForgetPassResetPasswordScreen> createState() =>
      _ForgetPassResetPasswordScreenState();
}

class _ForgetPassResetPasswordScreenState
    extends State<ForgetPassResetPasswordScreen> {
  TextEditingController passwordTEController = TextEditingController();
  TextEditingController confirmPasswordTEController = TextEditingController();

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
                  'Set Password',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'Minimum length password 8 character with Letter and number combination',
                  style: textTheme.titleMedium,
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
                            return 'Enter a password';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordTEController,
                        decoration: const InputDecoration(hintText: 'Password'),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a password';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        controller: confirmPasswordTEController,
                        decoration:
                            const InputDecoration(hintText: 'Confirm Password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          passwordTEController.text ==
                              confirmPasswordTEController.text) {
                        Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (route) => false,);
                      }
                      else{
                        Mymessage('Password not match', context);
                      }
                    },
                    child: const Text('Confirm')),
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
          style: TextStyle(
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
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignInScreen.name,
                      (route) => false,
                    );
                  }),
          ]),
    );
  }

  @override
  void dispose() {
    passwordTEController.dispose();
    confirmPasswordTEController.dispose();
    super.dispose();
  }
}
