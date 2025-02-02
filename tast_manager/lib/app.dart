import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tast_manager/ui/screen/add_new_task_screen.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/main_bottom_nav_screen.dart';
import 'package:tast_manager/ui/screen/forget_pass_email_verification_screen.dart';
import 'package:tast_manager/ui/screen/forget_pass_pin_verification_screen.dart';
import 'package:tast_manager/ui/screen/recover_reset_password_screen.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';
import 'package:tast_manager/ui/screen/sign_up_screen.dart';
import 'package:tast_manager/ui/screen/splash_screen.dart';
import 'package:tast_manager/ui/screen/update_screen.dart';
import 'package:tast_manager/utils/app_colors.dart';

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        colorSchemeSeed: AppColors.themColor,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
          titleMedium: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey),
        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            fixedSize: const Size(double.maxFinite, 16),
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
      ),

      initialRoute: '/',
      navigatorKey: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        late Widget widget;

        if (settings.name == SplashScreen.name) {
          widget = const SplashScreen();
        }
        else if (settings.name == SignInScreen.name) {
          widget = const SignInScreen();
        }
        else if (settings.name == ForgetPassEmailVerification.name) {
          widget = const ForgetPassEmailVerification();
        }
        else if (settings.name == SignUpScreen.name) {
          widget = const SignUpScreen();
        }
        else if (settings.name == ForgetPassPinVerification.name) {
          final String email = settings.arguments.toString();
          widget = ForgetPassPinVerification(email: email);
        }
        else if (settings.name == RecoverResetPasswordScreen.name) {
          final arguments = settings.arguments as Map<String, String>;
          widget = RecoverResetPasswordScreen(
            email: arguments['email'] ?? '',
            otp: arguments['otp'] ?? '',
          );
        }
        else if (settings.name == MainBottomNavScreen.name) {
          widget = const MainBottomNavScreen();
        }
        else if (settings.name == AddNewTaskScreen.name) {
          widget = const AddNewTaskScreen();
        }
        else if (settings.name == UpdateScreen.name) {
          widget = const UpdateScreen();
        }

        return MaterialPageRoute(
          builder: (context) => widget,
        );
      },
    );
  }
}
