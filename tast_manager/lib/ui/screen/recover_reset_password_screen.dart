import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tast_manager/ui/controllers/recover_reset_password_controller.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';
import '../../utils/app_colors.dart';
import '../../widgets/background_screen.dart';

class RecoverResetPasswordScreen extends StatefulWidget {
  static String name = 'forget/pass/reset/password';

  const RecoverResetPasswordScreen(
  {super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<RecoverResetPasswordScreen> createState() =>
      _RecoverResetPasswordScreenState();
}

class _RecoverResetPasswordScreenState
    extends State<RecoverResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final RecoverResetPasswordController _recoverResetPasswordController = Get
      .find<RecoverResetPasswordController>();

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
                        controller: _passwordTEController,
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
                        controller: _confirmPasswordTEController,
                        decoration:
                            const InputDecoration(hintText: 'Confirm Password'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          _passwordTEController.text ==
                              _confirmPasswordTEController.text) {
                        _postResetPassword();
                      } else {
                        Mymessage('Passwords do not match', context);
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

  /// Builds a rich text widget with a "Sign in".
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
                style: TextStyle(color: AppColors.themColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.offNamedUntil(SignInScreen.name, (route) => false);
                  }),
          ]),
    );
  }

  /// Sends the new password along with the OTP to reset the password.
  Future<void> _postResetPassword() async {
    bool isSuccess =await _recoverResetPasswordController.postResetPassword(
        email: widget.email, otp: widget.otp, password: _passwordTEController.text);

    if (isSuccess) {
      Get.offNamedUntil(
        SignInScreen.name,
        (route) => false);  //error
      Mymessage(_recoverResetPasswordController.message, context);
    } else {
      Mymessage(_recoverResetPasswordController.message, context);
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
