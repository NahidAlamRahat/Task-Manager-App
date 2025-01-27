
class Urls {
  static const String _baseURL = 'https://task.teamrabbil.com/api/v1';
  static const String registrationUrl = '$_baseURL/registration';
  static const String loginUrl = '$_baseURL/login';
  static const String createTaskUrl = '$_baseURL/createTask';
  static const String taskStatusCountUrl = '$_baseURL/taskStatusCount';
  static const String recoverResetPassUrl = '$_baseURL/RecoverResetPass';
  static const String profileUpdateUrl = '$_baseURL/profileUpdate';

  static String taskListByStatusUrl(String status) =>
      '$_baseURL/listTaskByStatus/$status';

  static String recoverVerifyEmailUrl(String email) =>
      '$_baseURL/RecoverVerifyEmail/$email';

  static String recoverVerifyOTP(String email, otp) =>
      '$_baseURL/RecoverVerifyOTP/$email/$otp';

  static String updateTaskStatusUrl(String id, status) =>
      '$_baseURL/updateTaskStatus/$id/$status';

  static String deleteTaskUrl(String id) =>
      '$_baseURL/deleteTask/$id';

}
