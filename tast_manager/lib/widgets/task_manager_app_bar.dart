import 'package:flutter/material.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';
import 'package:tast_manager/ui/screen/update_screen.dart';

import '../utils/app_colors.dart';

class TaskManagerAppBer extends StatelessWidget implements PreferredSizeWidget {
  const TaskManagerAppBer({
    super.key,
    required this.textTheme,
    this.fromUpdateProfile = false,
  });

   final bool fromUpdateProfile;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.themColor,
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if(fromUpdateProfile == false){
                  Navigator.pushNamed(context, UpdateScreen.name);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel?.fullName?? '',
                    style: textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    AuthController.userModel?.email ?? '',
                    style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),

                ],
              ),
            ),
          ),

          ///log Out button
          IconButton(onPressed: () {
            AuthController.clearData();
            Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (route) => false,);

          }, icon: const Icon(Icons.output)),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56);
}
