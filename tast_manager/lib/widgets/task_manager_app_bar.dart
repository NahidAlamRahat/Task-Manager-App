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

  final bool fromUpdateProfile; // Flag to indicate if the app bar is for update profile screen
  final TextTheme textTheme;  // The text theme for styling the title and subtitle

  @override
  State<TaskManagerAppBar> createState() => _TaskManagerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);  // Default app bar height
}

class _TaskManagerAppBarState extends State<TaskManagerAppBar> {
  @override
  void initState() {
    super.initState();
    _refreshUserData(); // Refresh user data when app bar is initialized
  }

  /// Function to refresh user data
  Future<void> _refreshUserData() async {
    await AuthController.getUserData(); // Fetch user data from the controller
    setState(() {}); // Update the UI with new data
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.themColor,  // Set the background color of the app bar
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0), // Padding around the avatar
            child: CircleAvatar(),  // Placeholder for user avatar
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.fromUpdateProfile == false) {
                  Navigator.pushNamed(context, UpdateScreen.name);  // Navigate to update screen if not already there
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,  // Align text to the left
                mainAxisAlignment: MainAxisAlignment.start,  // Align text to the top
                children: [
                  Text(
                    AuthController.userModel?.fullName ?? 'Unknown User',  // Display user's full name or a placeholder
                    style: widget.textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AuthController.userModel?.email ?? 'Unknown Email',  // Display user's email or a placeholder
                    style: widget.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Logout button with an icon
          IconButton(
            onPressed: () async {
              await AuthController.clearData();  // Clear user data
              Navigator.pushNamedAndRemoveUntil(
                context,
                SignInScreen.name,  // Navigate to sign-in screen after logout
                    (route) => false,  // Remove all previous routes from the stack
              );
            },
            icon: const Icon(Icons.output),  // Logout icon
          ),
        ],
      ),
    );
  }
}