import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

final messagesServiceProvider = Provider<MessagesService>((ref) => MessagesService());

class MessagesService {
  void showStyledToast(String msg, ToastificationType toastType, {String? title}) {
    toastification.dismissAll();
    toastification.show(
      title: Text(
        title ?? (toastType == ToastificationType.success ? 'Success' : 'Error'),
        style: const TextStyle(fontSize: 16),
      ),
      description: Text(
        msg,
        style: const TextStyle(fontSize: 14),
      ),
      type: toastType,
      style: ToastificationStyle.flatColored,
      progressBarTheme: ProgressIndicatorThemeData(
        color: toastType == ToastificationType.success
            ? Colors.green
            : toastType == ToastificationType.error
                ? Colors.red
                : Colors.orange,
      ),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}
