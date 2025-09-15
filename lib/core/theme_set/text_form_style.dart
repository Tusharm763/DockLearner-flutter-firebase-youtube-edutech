import 'package:dock_learner/core/theme_set/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomStyleForTextFormField {
  static TextStyle? formFieldTextStyle(BuildContext context) {
    return AppTheme.t8LabelMedium(context)?.copyWith(fontWeight: FontWeight.bold, fontFamily: 'SourGummy', letterSpacing: 1.5);
  }

  static InputDecoration formFieldDecoration(BuildContext context, IconData thisPrefixIcon, String thisHintText) {
    return InputDecoration(
      hintText: thisHintText,
      iconColor: AppTheme.onPrimary,
      filled: true,
      icon: Icon(thisPrefixIcon, size: 20.0, fill: 1.0),
      border: const UnderlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: AppTheme.tertiary, width: 5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: AppTheme.secondary, width: 4),
      ),
    );
  }
}
