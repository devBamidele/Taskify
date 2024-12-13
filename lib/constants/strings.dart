class AppStrings {
  // General
  static const String appName = 'Taskify';

  static const String unRegistered = 'Not registered yet? ';
  static const String cAccount = 'Create an Account';

  static const String loginTitle = 'Welcome back!';
  static const String loginSubtitle =
      "Log in to manage your tasks and stay on top of your work";

  static const String signUpTitle = 'Create account';
  static const String signUpSubtitle =
      'Sign up to easily manage your tasks and take control of your work.';

  static const List<String> requirements = [
    'Be at least 8 characters or more',
    'At least 1 uppercase and lowercase letter',
    'Must contain a digit or a number',
    "Must contain a special character e.g'@\$!%*?&'. ",
  ];

  static const String fetchTaskFailure = 'Failed to fetch tasks';
  static const String addTaskFailure = 'Failed to add tasks';
  static const String updateTaskFailure = 'Failed to update task';
  static const String deleteTaskFailure = 'Failed to delete task';

  // Authentication
  static const String emailLabel = "Email";
  static const String emailHint = 'example@gmail.com';
  static const String passwordLabel = "Password";
  static const String passwordHint = 'Password';
  static const String forgotPassword = "Forgot Password ?";
  static const String loginButton = 'Login';
  static const String signUpButton = 'Create account';
  static const String cfmPasswordLabel = 'Confirm Password';

  // Error Messages
  static const String errorInvalidEmail = 'The email address is not valid.';
  static const String errorInvalidCode = 'Invalid code';
  static const String errorOperationNotAllowed =
      'This authentication method is not enabled.';
  static const String errorWeakPassword = 'The password provided is too weak.';
  static const String errorNetworkRequestFailed = 'Poor internet connection';
  static const String errorUnknown =
      'An unknown error occurred. Please try again later.';
  static const String deviceOffline =
      'Network unavailable. Please try again later.';

  static const String disabledAccount = 'Your account has been disabled';
  static const String errorInvalidCredentials = 'Invalid email or password';

  static const String tooManyRequests = 'Too many requests, try again later';
  static const String differentCredentials =
      'Account exists with different credential';

  static const errorPermissionDenied =
      'You do not have permission to perform this action.';
  static const errorNotFound = 'The requested resource could not be found.';
  static const errorInvalidArgument = 'The provided data is invalid.';
  static const errorResourceExhausted =
      'The request exceeded the available resources or quotas.';
  static const errorDeadlineExceeded = 'The request took too long to complete.';
  static const errorAborted = 'The operation was aborted.';
  static const errorAlreadyExists = 'The resource already exists.';
  static const errorCanceled = 'The request was canceled.';
  static const errorFailedPrecondition =
      'The operation cannot be completed due to unmet preconditions.';

  static const userNotFound = 'User not found.';

  static const String noTasksAvailable = 'No tasks available';

  static const String logoutDialogMessage = 'Are you sure you want to logout?';
}
