import 'package:tast_manager/data/models/task_model.dart';

/// A utility class that defines all API endpoint URLs used in the application.
class Urls {
  /// Base URL for the API
  static const String _baseURL = 'https://task.teamrabbil.com/api/v1';

  /// Endpoint for user registration
  static const String registrationUrl = '$_baseURL/registration';

  /// Endpoint for user login
  static const String loginUrl = '$_baseURL/login';

  /// Endpoint for creating a new task
  static const String createTaskUrl = '$_baseURL/createTask';

  /// Endpoint for fetching task status counts
  static const String taskStatusCountUrl = '$_baseURL/taskStatusCount';

  /// Endpoint for resetting the password during account recovery
  static const String RecoverResetPassUrl = '$_baseURL/RecoverResetPass';

  /// Generates the URL for fetching a task list by its status.
  ///
  /// Example:
  /// ```dart
  /// String url = Urls.taskListByStatusUrl('pending');
  /// ```
  static String taskListByStatusUrl(String status) =>
      '$_baseURL/listTaskByStatus/$status';

  /// Generates the URL for verifying an email during account recovery.
  ///
  /// Example:
  /// ```dart
  /// String url = Urls.recoverVerifyEmailUrl('user@example.com');
  /// ```
  static String recoverVerifyEmailUrl(String email) =>
      '$_baseURL/RecoverVerifyEmail/$email';

  /// Generates the URL for verifying an OTP during account recovery.
  ///
  /// Example:
  /// ```dart
  /// String url = Urls.recoverVerifyOTP('user@example.com', '123456');
  /// ```
  static String recoverVerifyOTP(String email, otp) =>
      '$_baseURL/RecoverVerifyOTP/$email/$otp';

  /// Generates the URL for updating the status of a task.
  ///
  /// Example:
  /// ```dart
  /// String url = Urls.updateTaskStatusUrl('task123', 'completed');
  /// ```
  static String updateTaskStatusUrl(String id, status) =>
      '$_baseURL/updateTaskStatus/$id/$status';
}
