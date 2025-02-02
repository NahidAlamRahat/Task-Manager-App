import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tast_manager/ui/screen/recover_reset_password_screen.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../../widgets/background_screen.dart';
import '../../widgets/show_snackber_message.dart';

class ForgetPassPinVerification extends StatefulWidget {
  static String name = 'forget/pass/pin/verification';

  final String email;

  const ForgetPassPinVerification({
    super.key,
    required this.email,
  });

  @override
  State<ForgetPassPinVerification> createState() =>
      _ForgetPassPinVerificationState();
}

class _ForgetPassPinVerificationState extends State<ForgetPassPinVerification> {
  TextEditingController otpTEController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// input a 6-digit OTP for verification.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
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
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      controller: otpTEController,
                      appContext: context,
                    )),
                const SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _getPinVerify();
                    }
                  },
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Sends the OTP entered by the user to the server for validation.
  Future<void> _getPinVerify() async {
    // API Call
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyOTP(widget.email, otpTEController.text));

    if (networkResponse.statusData?['status'] == 'success') {
     Get.toNamed(
          arguments: {'otp': otpTEController.text, 'email': widget.email},
          RecoverResetPasswordScreen.name);
    } else {
      Mymessage('Invalid OTP. Please try again.', context);
    }
  }

  @override
  void dispose() {
    otpTEController.dispose();
    super.dispose();
  }
}
