import 'package:flutter/material.dart';

class InputsDeocrations {
  static InputDecoration textFormDecoration({
    required String labelText,
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      focusColor: Colors.grey,
      iconColor: Colors.grey,
      hoverColor: Colors.grey,
      fillColor: Colors.grey,
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }
}
