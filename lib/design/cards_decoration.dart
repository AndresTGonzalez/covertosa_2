import 'package:covertosa_2/design/design.dart';
import 'package:flutter/material.dart';

class CardsDecoration {
  static BoxDecoration homeCardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(100),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
