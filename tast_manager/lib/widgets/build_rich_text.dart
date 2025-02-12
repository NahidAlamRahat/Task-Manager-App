import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../ui/screen/sign_in_screen.dart';
import '../utils/app_colors.dart';

class BuildRichText{
  /// Builds a rich text widget with a "Sign in".
 static Widget buildRichText() {
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

            }