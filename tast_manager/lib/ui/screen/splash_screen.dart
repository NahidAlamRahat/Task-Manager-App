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

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    moveToNextScreen();
  }


  Future<void> moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    bool userLoggedIn = await AuthController.userLoggedIn();
    if(userLoggedIn){
      Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);

    }
    else{
      Navigator.pushReplacementNamed(context, SignInScreen.name);

    }

}


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
      body: BackgroundScreen(
        child: Center(
              child: AppLogo(),
        ),
      ),
    );
  }
}
