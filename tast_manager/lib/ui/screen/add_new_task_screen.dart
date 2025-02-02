import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../../widgets/background_screen.dart';
import '../../widgets/show_snackber_message.dart';
import '../../widgets/task_manager_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  static String name = 'add/new/task/screen';

  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _newTaskAddedInProgress = false;

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
                  key: _formKey,
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
                        keyboardType: TextInputType.text,
                        controller: _titleTEController,
                        decoration: const InputDecoration(hintText: 'Subject'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a Description';
                          }
                          return null;
                        },
                        controller: _descriptionTEController,
                        decoration: const InputDecoration(hintText: 'Description'),
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Visibility(
                  visible: _newTaskAddedInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addNewTaskItem();
                      }
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTaskItem() async {
    _newTaskAddedInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New",
    };

    final NetworkResponse networkResponse = await NetworkCaller.postRequest(
        url: Urls.createTaskUrl, body: requestBody);

    _newTaskAddedInProgress = false;
    setState(() {});

    if (networkResponse.isSuccess) {
      _clearData();
      Mymessage('New Task Added', context);
      Get.off(true);
    } else {
      debugPrint(networkResponse.errorMessage);
      debugPrint(networkResponse.statusCode.toString());
      Mymessage('Added field', context);
    }
  }

  void _clearData() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
