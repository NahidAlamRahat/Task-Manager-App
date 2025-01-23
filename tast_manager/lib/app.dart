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
      debugShowCheckedModeBanner: false,  // Disable the debug banner in the app
      theme: ThemeData(
        colorSchemeSeed: AppColors.themColor,  // Use the theme color from AppColors
        textTheme: const TextTheme(
          titleLarge: TextStyle(  // Style for large titles
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
          titleMedium: TextStyle(  // Style for medium titles
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(  // Customize the input decoration theme
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),  // Rounded border radius
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),  // Rounded border radius for focused state
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),  // Rounded border radius for error state
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(  // Customize the ElevatedButton theme
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themColor,  // Button background color
            foregroundColor: Colors.white,  // Button text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),  // Button border radius
            ),
            fixedSize: const Size(double.maxFinite, 16),  // Set the fixed size for the button
            textStyle: const TextStyle(  // Button text style
              color: Colors.white,
            ),
          ),
        ),
      ),
      initialRoute: '/',  // Initial screen when the app starts
      navigatorKey: navigatorKey,  // Set the navigator key for navigation management
      onGenerateRoute: (RouteSettings settings) {  // Handle routing to different screens
        late Widget widget;  // Define the widget to return based on the route

        if (settings.name == SplashScreen.name) {
          widget = const SplashScreen();  // Navigate to SplashScreen
        }
        else if (settings.name == SignInScreen.name) {
          widget = const SignInScreen();  // Navigate to SignInScreen
        }
        else if (settings.name == ForgetPassEmailVerification.name) {
          widget = const ForgetPassEmailVerification();  // Navigate to ForgetPassEmailVerification
        }
        else if (settings.name == SignUpScreen.name) {
          widget = const SignUpScreen();  // Navigate to SignUpScreen
        }
        else if (settings.name == ForgetPassPinVerification.name) {
          final String email = settings.arguments.toString();  // Get email from route arguments
          widget = ForgetPassPinVerification(email: email);  // Navigate to ForgetPassPinVerification with email
        }
        else if (settings.name == RecoverResetPasswordScreen.name) {
          final arguments = settings.arguments as Map<String, String>;  // Get arguments as a map
          widget = RecoverResetPasswordScreen(
            email: arguments['email'] ?? '',  // Get email from arguments
            otp: arguments['otp'] ?? '',  // Get OTP from arguments
          );
        }
        else if (settings.name == MainBottomNavScreen.name) {
          widget = const MainBottomNavScreen();  // Navigate to MainBottomNavScreen
        }
        else if (settings.name == AddNewTaskScreen.name) {
          widget = const AddNewTaskScreen();  // Navigate to AddNewTaskScreen
        }
        else if (settings.name == UpdateScreen.name) {
          widget = const UpdateScreen();  // Navigate to UpdateScreen
        }

        return MaterialPageRoute(
          builder: (context) => widget,  // Return the widget based on the route
        );
      },
    );
  }
}
