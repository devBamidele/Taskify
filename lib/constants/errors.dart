import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';

import 'index.dart';

String firebaseAuthErrMsg(FirebaseException e) {
  log('Firebase Authentication error, code : ${e.code}');
  switch (e.code) {
    case 'email-already-in-use':
      return AppStrings.errorInvalidCredentials;
    case 'invalid-email':
      return AppStrings.errorInvalidEmail;
    case 'invalid-verification-code':
      return AppStrings.errorInvalidCode;
    case 'user-disabled':
      return AppStrings.disabledAccount;
    case 'user-not-found':
      return AppStrings.errorInvalidCredentials;
    case 'wrong-password' || 'invalid-credential' || 'user-not-found':
      return AppStrings.errorInvalidCredentials;
    case 'too-many-requests':
      return AppStrings.tooManyRequests;
    case 'operation-not-allowed':
      return AppStrings.errorOperationNotAllowed;
    case 'weak-password':
      return AppStrings.errorWeakPassword;
    case 'network-request-failed':
      return AppStrings.errorNetworkRequestFailed;
    case 'account-exists-with-different-credential':
      return AppStrings.differentCredentials;
    default:
      return AppStrings.errorUnknown;
  }
}

String firestoreErrMsg(FirebaseException e) {
  log('Firebase Firestore error, code : ${e.code}');

  switch (e.code) {
    case 'user-disabled':
      return AppStrings.disabledAccount;
    case 'user-not-found':
      return AppStrings.userNotFound;
    case 'too-many-requests':
      return AppStrings.tooManyRequests;
    case 'network-request-failed':
      return AppStrings.errorNetworkRequestFailed;
    case 'unavailable':
      return AppStrings.deviceOffline;
    case 'permission-denied':
      return AppStrings.errorPermissionDenied;
    case 'not-found':
      return AppStrings.errorNotFound;
    case 'invalid-argument':
      return AppStrings.errorInvalidArgument;
    case 'resource-exhausted':
      return AppStrings.errorResourceExhausted;
    case 'deadline-exceeded':
      return AppStrings.errorDeadlineExceeded;
    case 'aborted':
      return AppStrings.errorAborted;
    case 'already-exists':
      return AppStrings.errorAlreadyExists;
    case 'canceled':
      return AppStrings.errorCanceled;
    case 'failed-precondition':
      return AppStrings.errorFailedPrecondition;

    default:
      return AppStrings.errorUnknown;
  }
}
