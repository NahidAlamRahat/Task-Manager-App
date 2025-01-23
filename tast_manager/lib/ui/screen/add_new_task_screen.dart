import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  TextEditingController _tiitleTEController = TextEditingController(); // Controller for the task title
  TextEditingController _descriptionTEController = TextEditingController(); // Controller for the task description
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key to manage form state
  bool _newTaskAddedInProgress = false; // To show/hide progress indicator while adding task

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme), // Custom app bar
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
                  style: textTheme.titleLarge, // Style for the title
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey, // Attach form key for validation
                  child: Column(
                    children: [
                      // Title input field
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a subject'; // Validation for empty title
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text, // Adjust keyboard type
                        controller: _tiitleTEController, // Controller for title field
                        decoration: const InputDecoration(hintText: 'Subject'), // Field decoration
                      ),
                      const SizedBox(height: 12),
                      // Description input field
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a Description'; // Validation for empty description
                          }
                          return null;
                        },
                        controller: _descriptionTEController, // Controller for description field
                        decoration: const InputDecoration(hintText: 'Description'), // Field decoration
                        maxLines: 6, // Allow multiple lines for description
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Task add button or loading indicator based on progress
                Visibility(
                  visible: _newTaskAddedInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()), // Show loading indicator when in progress
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) { // Validate form fields
                        _addNewTaskItem(); // Proceed with task creation
                      }
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined), // Button icon
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Function to add a new task item by sending a POST request to the server
  Future<void> _addNewTaskItem() async {
    _newTaskAddedInProgress = true;
    setState(() {}); // Update state to show loading indicator

    // Prepare the request body with task data
    Map<String, dynamic> requestBody = {
      "title": _tiitleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New", // Default task status is "New"
    };

    // Send POST request to the server
    final NetworkResponse networkResponse = await NetworkCaller.postRequest(
        url: Urls.createTaskUrl, body: requestBody);

    _newTaskAddedInProgress = false;
    setState(() {}); // Hide loading indicator after the request is done

    // Handle success or failure based on the response
    if (networkResponse.isSuccess) {
      _clearData(); // Clear the input fields after task creation
      Mymessage('New Task Added', context); // Show success message
    } else {
      debugPrint(networkResponse.errorMessage); // Log error message
      debugPrint(networkResponse.statusCode.toString()); // Log status code
      Mymessage('Added field', context); // Show failure message
    }
  }

  // Function to clear the input fields after task creation
  void _clearData() {
    _tiitleTEController.clear();
    _descriptionTEController.clear();
  }

  // Dispose method to clean up controllers when the screen is removed
  @override
  void dispose() {
    _tiitleTEController.dispose(); // Dispose the title controller
    _descriptionTEController.dispose(); // Dispose the description controller
    super.dispose(); // Call dispose on the superclass
  }
}
