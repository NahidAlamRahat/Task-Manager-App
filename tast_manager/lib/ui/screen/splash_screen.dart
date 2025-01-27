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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller and animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -1), // Start from top (outside the screen)
      end: Offset.zero, // End at the center
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(); // Start the animation
    moveToNextScreen(); // Start the screen transition logic
  }

  Future<void> moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    bool userLoggedIn = await AuthController.userLoggedIn();
    if (userLoggedIn) {
      Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
    } else {
      Navigator.pushReplacementNamed(context, SignInScreen.name);
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundScreen(
        child: Center(
          child: SlideTransition(
            position: _animation, // Attach animation to the logo
            child: const AppLogo(),
          ),
        ),
      ),
    );
  }
}
