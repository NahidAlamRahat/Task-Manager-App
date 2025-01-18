import 'package:flutter/material.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';
import 'package:tast_manager/ui/screen/update_screen.dart';

import '../utils/app_colors.dart';

class TaskManagerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({
    super.key,
    required this.textTheme,
    this.fromUpdateProfile = false,
  });

  final bool fromUpdateProfile;
  final TextTheme textTheme;

  @override
  State<TaskManagerAppBar> createState() => _TaskManagerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _TaskManagerAppBarState extends State<TaskManagerAppBar> {
  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  /// User data refresh function
  Future<void> _refreshUserData() async {
    await AuthController.getUserData();
    setState(() {});
  }

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
                if (widget.fromUpdateProfile == false) {
                  Navigator.pushNamed(context, UpdateScreen.name);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel?.fullName ?? 'Unknown User',
                    style: widget.textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AuthController.userModel?.email ?? 'Unknown Email',
                    style: widget.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Logout button
          IconButton(
            onPressed: () async {
              await AuthController.clearData();
              Navigator.pushNamedAndRemoveUntil(
                context,
                SignInScreen.name,
                    (route) => false,
              );
            },
            icon: const Icon(Icons.output),
          ),
        ],
      ),
    );
  }
}
