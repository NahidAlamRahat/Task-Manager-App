import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tast_manager/ui/controllers/auth_controller.dart';
import 'package:tast_manager/ui/screen/sign_in_screen.dart';
import 'package:tast_manager/ui/screen/update_screen.dart';
import 'package:tast_manager/widgets/show_custom_alert_dialog.dart';
import '../utils/app_colors.dart';

class TaskManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({
    super.key,
    required this.textTheme,
    this.fromUpdateProfile = false,
  });

  final bool fromUpdateProfile;
  final TextTheme textTheme;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return AppBar(
      backgroundColor: AppColors.themColor,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => CircleAvatar(
              backgroundImage: _getValidImage(authController.userModel.value?.photo),
              child: (authController.userModel.value?.photo == null ||
                  authController.userModel.value!.photo!.isEmpty)
                  ? const Icon(Icons.person_outline)
                  : null,
            )),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(context, UpdateScreen.name);
                if (result == true) {
                  await authController.getUserData(); // Update AppBar after returning
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    authController.userModel.value?.fullName ?? 'Unknown User',
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  Obx(() => Text(
                    authController.userModel.value?.email ?? 'Unknown Email',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              showCustomAlertDialog(
                context,
                text: const Text(
                  'Logout!',
                  style: TextStyle(fontSize: 20),
                ),
                message: 'Are you sure you want to logout?',
                onConfirm: () async {
                  await authController.clearData();
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

  ImageProvider? _getValidImage(String? base64String) {
    try {
      if (base64String != null && base64String.isNotEmpty) {
        final cleanedBase64 = base64String.startsWith("data:image")
            ? base64String.split(",").last
            : base64String;
        return MemoryImage(base64Decode(cleanedBase64));
      }
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
    }
    return null; // Return null if decoding fails
  }
}
