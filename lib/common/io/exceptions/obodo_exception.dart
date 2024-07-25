import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:obodo_module_starter/common/io/exceptions/obodo_response_type.dart';

class ObodoException implements Exception {
  ObodoException({
    required this.statusCode,
    required this.message,
    required this.description,
    required this.cause,
    this.responseCode,
    this.body,
  });

  factory ObodoException.fromTypeError(TypeError error) {
    log('ObodoException => TypeError $error');
    return ObodoException(
        statusCode: -1,
        message: '',
        description: error.toString(),
        cause: Exception(error));
  }

  factory ObodoException.fromHttpError(DioException error) {
    final response = error.response;
    final statusCode = error.response?.statusCode ?? -1;
    final statusMessage = response?.statusMessage ?? '';
    final dynamic body = response?.data;

    var message = '';
    var description = '';
    var newErrorBody = <String, dynamic>{};
    Exception cause = error;

    if (DioExceptionType.connectionTimeout == error.type ||
        DioExceptionType.receiveTimeout == error.type ||
        DioExceptionType.sendTimeout == error.type) {
      message = 'Connection Unavailable';
      description = "We're sorry, but it seems that we are currently "
          'experiencing connection issues. '
          'Please check your internet connection and try again. Thank you';
    } else if (DioExceptionType.connectionError == error.type ||
        error.error is SocketException) {
      message = 'Connection Unavailable';
      description = "We're sorry, but it seems that we are currently "
          'experiencing connection issues. '
          'Please check your internet connection and try again. Thank you';
    } else if (null == response || statusCode == 500) {
      message = 'Oops! Something Went Wrong';
      description = 'We encountered a problem while processing your request. '
          'We’re on it and will have it fixed soon. Please try again later.';
    } else if (DioExceptionType.badResponse == error.type ||
        (statusCode >= 501 && statusCode <= 599)) {
      // The backend will most times return an HTML String here
      // We'll just try to detect if it's an XML and send a reformed message
      final trimmedStatusMessage = statusMessage.trim();
      if (trimmedStatusMessage.isNotEmpty &&
          statusMessage.startsWith('<') &&
          statusMessage.endsWith('>')) {
        message = 'Oops! Service Unavailable';
        description = 'We apologize, but we are currently unable to process '
            'your request. Please try again later. '
            'Thank you for your patience.';
      } else {
        message = 'Error Occurred';
        description =
            'An unexpected error occurred while processing your request. '
            'Please try again later. If the problem persists, '
            'please contact support for assistance.';
      }
    }

    if (null != body && body is Map<String, dynamic>) {
      newErrorBody = body;
      cause = _buildErrorFromBodyIfNeeded(cause, newErrorBody);
    } else if (null != body && body is String) {
      try {
        newErrorBody = jsonDecode(body) as Map<String, dynamic>;
        // Let's provide further assist by reading the
        // body to know the errors, we can also update the cause
        cause = _buildErrorFromBodyIfNeeded(cause, newErrorBody);
      } on FormatException catch (e) {
        log('Failed to decode the body $e');
      }
    }

    // Let's update the message and description from the newErrorBody
    message = newErrorBody[responseMessageKey] as String? ?? message;
    description = newErrorBody[responseDescriptionKey] as String? ??
        newErrorBody[responseDescriptionKey2] as String? ??
        description;

    return ObodoException(
        statusCode: statusCode,
        message: message,
        description: description,
        cause: cause,
        body: newErrorBody,
        responseCode: newErrorBody[responseCodeKey]?.toString());
  }

  factory ObodoException.empty() = _EmptyObodoException;

  factory ObodoException.fromMessage(String message) =
      _FromMessageObodoException;

  static const responseCodeKey = 'status';
  static const identifierKey = 'identifier';
  static const tokenDataKey = 'tokenData';
  static const responseMessageKey = 'message';
  static const responseDescriptionKey = 'message';
  static const responseDescriptionKey2 = 'description';
  static const ussdCodeKey = 'ussdCode';
  static const domainsKey = 'domains';
  static const usernameKey = 'name';
  static const phone = 'phone';
  static const email = 'email';
  static const customerAccountDetailsKey = 'customerAccountDetails';

  final int statusCode;
  final String? responseCode;
  final String message;
  final String description;
  final Map<String, dynamic>? body;
  final Exception cause;

  @override
  String toString() {
    return 'ObodoException: status=$statusCode, '
        'responseCode=$responseCode, message=$message,'
        ' description=$description, '
        'body=$body, cause=$cause';
  }

  static Exception _buildErrorFromBodyIfNeeded(
      Exception originalCause, Map<String, dynamic> errorBody) {
    if (errorBody.containsKey(responseCodeKey)) {
      final code =
          ObodoResponseType.fromCode('${errorBody[responseCodeKey] ?? ''}');
      log(code.toString(), name: "code");
      switch (code) {
        case ObodoResponseType.inactiveAccount:
          return InActiveAccountException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
            phoneNumber: errorBody[phone] as String? ?? '',
            email: errorBody[email] as String? ?? '',
          );
        case ObodoResponseType.userAccountNotExist:
          return UserAccountNotExistException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.userAccountExists:
          return UserAccountExistsException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.incorrectOrMissingParams:
          return IncorrectOrMissingParametersException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.serverError:
          return ServerErrorException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.passwordMismatch:
          return PasswordMismatchException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.accountNotVerified:
          return AccountNotVerifiedException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.incorrectOtp:
          return IncorrectOtpException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.userCouldNotBeCreated:
          return UserNotCreatedException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.somethingIsNotRight:
          return SomethingNotRightException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.pendingApproval:
          return PendingApprovalException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.tutorNotAssigned:
          return TutorNotAssignedException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.audioDoesNotExist:
          return AudioDoesNotExistException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.userDeclinedAppAuthorization:
          return UserDeclinedAppAuthorizationException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.requestWithEmailExists:
          return RequestWithEmailAlreadyExistsException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.oneMeetingPerWeek:
          return OneMeetingPerWeekException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.recordedAudioNotFound:
          return RecordedAudioNotFoundException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.taskAlreadySubmitted:
          return TaskAlreadySubmittedException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.invalidFlashcard:
          return InvalidFlashcardException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.tutorNotAssociatedWithStudent:
          return TutorNotAssociatedWithStudentException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.flashcardAlreadyPurchased:
          return FlashcardAlreadyPurchasedException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.invalidPlan:
          return InvalidPlanException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.oneMeetingInFreeTrial:
          return OneMeetingInFreeTrialException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.transcriptNotFound:
          return TranscriptNotFoundException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.userBlocked:
          return UserBlockedContactAdminException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.feedbackNotFound:
          return FeedbackNotFoundException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.zoomCredentialsUsed:
          return ZoomCredentialsUsedWithObodoException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.forbiddenAccess:
          return ForbiddenAccessException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.meetingNotFound:
          return MeetingNotFoundException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.monthlyProgressReportPaidOnly:
          return MonthlyReportForPaidPlansOnlyException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.invalidSlots:
          return InvalidSlotsException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.forcedUpdateRequired:
          return ForcedUpdateRequiredException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.receiptInvalid:
          return ReceiptInvalidException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );

        case ObodoResponseType.productAlreadyPurchased:
          return ProductAlreadyPurchasedException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.userTransactionDoesNotExist:
          return UserTransactionDoesNotExistException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.productNotFound:
          return ProductNotFoundException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        case ObodoResponseType.invalidSignedPayload:
          return InvalidSignedPayloadException(
            message: errorBody[responseMessageKey] as String? ?? '',
            cause: originalCause,
            responseCode: errorBody[responseCodeKey] as String? ?? '-1',
          );
        default:
          break;
      }
    }
    return originalCause;
  }
}

class _EmptyObodoException extends ObodoException {
  _EmptyObodoException()
      : super(
          message: '',
          description: '',
          cause: Exception(),
          statusCode: -1,
        );
}

class _FromMessageObodoException extends ObodoException {
  _FromMessageObodoException(String message)
      : super(
          message: '',
          description: message,
          cause: Exception(),
          statusCode: -1,
        );
}

// Define all new exception classes based on the provided list
class UserAccountNotExistException implements Exception {
  UserAccountNotExistException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class UserAccountExistsException implements Exception {
  UserAccountExistsException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class IncorrectOrMissingParametersException implements Exception {
  IncorrectOrMissingParametersException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class ServerErrorException implements Exception {
  ServerErrorException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class PasswordMismatchException implements Exception {
  PasswordMismatchException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class AccountNotVerifiedException implements Exception {
  AccountNotVerifiedException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class IncorrectOtpException implements Exception {
  IncorrectOtpException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class UserNotCreatedException implements Exception {
  UserNotCreatedException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class SomethingNotRightException implements Exception {
  SomethingNotRightException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class PendingApprovalException implements Exception {
  PendingApprovalException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class TutorNotAssignedException implements Exception {
  TutorNotAssignedException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class AudioDoesNotExistException implements Exception {
  AudioDoesNotExistException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class UserDeclinedAppAuthorizationException implements Exception {
  UserDeclinedAppAuthorizationException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class RequestWithEmailAlreadyExistsException implements Exception {
  RequestWithEmailAlreadyExistsException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class OneMeetingPerWeekException implements Exception {
  OneMeetingPerWeekException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class RecordedAudioNotFoundException implements Exception {
  RecordedAudioNotFoundException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class TaskAlreadySubmittedException implements Exception {
  TaskAlreadySubmittedException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class InvalidFlashcardException implements Exception {
  InvalidFlashcardException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class TutorNotAssociatedWithStudentException implements Exception {
  TutorNotAssociatedWithStudentException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class FlashcardAlreadyPurchasedException implements Exception {
  FlashcardAlreadyPurchasedException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class InvalidPlanException implements Exception {
  InvalidPlanException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class OneMeetingInFreeTrialException implements Exception {
  OneMeetingInFreeTrialException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class TranscriptNotFoundException implements Exception {
  TranscriptNotFoundException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class UserBlockedContactAdminException implements Exception {
  UserBlockedContactAdminException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class FeedbackNotFoundException implements Exception {
  FeedbackNotFoundException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class ZoomCredentialsUsedWithObodoException implements Exception {
  ZoomCredentialsUsedWithObodoException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class ForbiddenAccessException implements Exception {
  ForbiddenAccessException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class MeetingNotFoundException implements Exception {
  MeetingNotFoundException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class MonthlyReportForPaidPlansOnlyException implements Exception {
  MonthlyReportForPaidPlansOnlyException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class InvalidSlotsException implements Exception {
  InvalidSlotsException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class ForcedUpdateRequiredException implements Exception {
  ForcedUpdateRequiredException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class ReceiptInvalidException implements Exception {
  ReceiptInvalidException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class ProductPurchasedSuccessfullyException implements Exception {
  ProductPurchasedSuccessfullyException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class ProductAlreadyPurchasedException implements Exception {
  ProductAlreadyPurchasedException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class UserTransactionDoesNotExistException implements Exception {
  UserTransactionDoesNotExistException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class ProductNotFoundException implements Exception {
  ProductNotFoundException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class InvalidSignedPayloadException implements Exception {
  InvalidSignedPayloadException({
    required this.responseCode,
    required this.message,
    required this.cause,
  });

  final String responseCode;
  final String message;
  final Exception cause;
}

class InActiveAccountException implements Exception {
  InActiveAccountException({
    required this.responseCode,
    required this.message,
    required this.cause,
    required this.phoneNumber,
    required this.email,
  });

  final String responseCode;
  final String message;
  final Exception cause;
  final String phoneNumber;
  final String email;
}
