import 'package:flutter/material.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/main_bottom_nav_screen.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';
import 'package:tast_manager/widgets/background_screen.dart';

import '../../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  /// Called when the screen is initialized.
  /// Initiates the move to the next screen based on user login status.
  @override
  void initState() {
    super.initState();
    moveToNextScreen();  // Calls the function to check if the user is logged in
  }

  /// Function to check if the user is logged in
  /// Waits for 2 seconds, then navigates to the appropriate screen
  Future<void> moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));  // Wait for 2 seconds before checking login status
    bool userLoggedIn = await AuthController.userLoggedIn();  // Checks if the user is logged in
    if (userLoggedIn) {
      setState(() {});  // Rebuilds the widget
      Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);  // Navigate to the main screen if logged in
    } else {
      Navigator.pushReplacementNamed(context, SignInScreen.name);  // Navigate to SignIn screen if not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BackgroundScreen(
        child: Center(
          child: AppLogo(),  // Display the app logo in the center of the screen
        ),
      ),
    );
  }
}