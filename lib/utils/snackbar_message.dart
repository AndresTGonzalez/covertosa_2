import 'package:covertosa_2/design/app_colors.dart';
import 'package:flutter/material.dart';

class SnackbarMessage {
  static void show({
    required BuildContext context,
    required String message,
    required bool isError,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.danger : AppColors.success,
      ),
    );
  }
}
