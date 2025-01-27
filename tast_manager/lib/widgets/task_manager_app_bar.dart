import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';
import 'package:tast_manager/ui/screen/update_screen.dart';
import 'package:tast_manager/widgets/show_custom_alert_dialog_function.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshUserData();
    setState(() {});
  }

  Future<void> _refreshUserData() async {
    setState(() {
      _isLoading = true; // Show loading
    });
    await AuthController.getUserData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.themColor,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: _getValidImage(AuthController.userModel?.photo),
              child: (AuthController.userModel?.photo == null ||
                  AuthController.userModel!.photo!.isEmpty)
                  ? const Icon(Icons.person_outline) // Default icon show korbe
                  : null,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (!widget.fromUpdateProfile) {
                  final result = await Navigator.pushNamed(context, UpdateScreen.name);
                  if (result == true) {
                    await _refreshUserData(); // Refresh data on update
                  }
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
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            IconButton(
              onPressed: () {
                ShowCustomAlertDialog(
                  context,
                  text: const Text(
                    'Logout!',
                    style: TextStyle(fontSize: 20),
                  ),
                  message: 'Are you sure you want to logout?',
                  onConfirm: () async {
                    await AuthController.clearData();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignInScreen.name,
                          (route) => false,
                    );
                  },
                );
              },
              icon: const Icon(Icons.output),
            ),
        ],
      ),
    );
  }

  /// validate and decode Base64 image
  ImageProvider? _getValidImage(String? base64String) {
    setState(() {});
    try {
      if (base64String != null && base64String.isNotEmpty) {
        // Remove any "data:image/png;base64," prefix if present
        final cleanedBase64 = base64String.startsWith("data:image")
            ? base64String.split(",").last
            : base64String;

        // Decode and return MemoryImage if valid
        return MemoryImage(base64Decode(cleanedBase64));
      }
    } catch (e) {
      debugPrint('Error decoding base64 image: $e'); // Log the error for debugging
    }
    return null; // Return null if decoding fails
  }
}
