import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tast_manager/ui/screen/forget_pass_reset_password_screen.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';

import '../../utils/app_colors.dart';
import '../../widgets/background_screen.dart';

class ForgetPassPinVerification extends StatefulWidget {
  static String name = 'forget/pass/pin/verification';

  const ForgetPassPinVerification({super.key});

  @override
  State<ForgetPassPinVerification> createState() =>
      _ForgetPassPinVerificationState();
}

class _ForgetPassPinVerificationState extends State<ForgetPassPinVerification> {
  TextEditingController pinTEController = TextEditingController();
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
                  'Pin Verification',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'A 6 digits of OTP has been sent to your email address',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                Form(
                    key: formKey,
                    child: PinCodeTextField(
                      validator: (String? value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.length != 6) {
                          return 'Enter a valid OTP number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      controller: pinTEController,
                      appContext: context,
                    )),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Navigate to the next screen
                      Navigator.pushNamed(
                          context, ForgetPassResetPasswordScreen.name);
                    }
                  },
                  child: const Icon(Icons.arrow_circle_right_outlined),
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
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignInScreen.name,
                      (value) => false,
                    );
                  }),
          ]),
    );
  }

  @override
  void dispose() {
    pinTEController.dispose();
    super.dispose();
  }
}
