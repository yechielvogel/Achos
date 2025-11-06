import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/general.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is FormatException) {
      return 'Invalid response format';
    } else if (error is TimeoutException) {
      return 'The request timed out';
    } else if (error is Exception &&
        error
            .toString()
            .contains('No address associated with hostname, errno = 7)')) {
      return 'Network error occurred';
    } else if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    } else if (error is String) {
      return error;
    } else if (error is Error) {
      // Handle Dart Errors
      return 'An unexpected error occurred: ${error.toString()}';
    } else if (error is StackTrace) {
      // Handle StackTrace
      return 'An error occurred: ${error.toString()}';
    } else {
      // should add FirebaseCrashlytics
      // FirebaseCrashlytics.instance.recordError(
      //   error,
      //   null,
      //   reason: 'Unhandled error in ErrorHandler',
      // );
      return 'An unknown error occurred';
    }
  }

  static void logError(dynamic error) {
    print('Error logged: $error');
  }

  static void setError(dynamic error) {
    final message = getErrorMessage(error);
    logError(error);
  }
}

class ErrorSnackbar extends ConsumerWidget {
  const ErrorSnackbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorMessage = ref.watch(errorProvider);

    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(errorMessage)),
            // need to change to use style theme and have a status red color there
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(errorProvider.notifier).state = null;
      });
    }

    return const SizedBox.shrink();
  }
}
