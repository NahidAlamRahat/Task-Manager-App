import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tast_manager/ui/screen/bottom_nav_screen/main_bottom_nav_screen.dart';
import 'package:tast_manager/ui/screen/forget_pass_email_verification_screen.dart';
import 'package:tast_manager/ui/screen/sign_up_screen.dart';
import 'package:tast_manager/widgets/show_snackber_message.dart';
import 'package:tast_manager/widgets/task_manager_app_bar.dart';

import '../../utils/app_colors.dart';
import '../../widgets/background_screen.dart';

class AddNewTaskScreen extends StatefulWidget {
  static String name = 'add/new/task/screen';

  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController emailTEController = TextEditingController();
  TextEditingController passwordTEController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme),
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Add New Task',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a subject';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailTEController,
                        decoration: const InputDecoration(hintText: 'Subject'),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a Description';
                          }
                          return null;
                        },
                        controller: passwordTEController,
                        decoration: const InputDecoration(hintText: 'Description'),
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      ///code here
                      Mymessage('added', context);
                      
                    }
                  },
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    emailTEController.dispose();
    passwordTEController.dispose();
    super.dispose();
  }
}
