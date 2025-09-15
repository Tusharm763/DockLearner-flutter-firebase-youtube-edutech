import 'package:dock_learner/core/theme_set/theme_colors.dart';
import 'package:flutter/material.dart';

class ShowSnackInfo {
  final String contentText;
  final Color backgroundColor;
  final Duration duration;

  // final SnackBarBehavior behavior;
  // final double elevation;
  // final EdgeInsets margin;
  // final EdgeInsets padding;

  const ShowSnackInfo._({
    required this.contentText,
    required this.backgroundColor,
    this.duration = const Duration(seconds: 4),
    // this.behavior = SnackBarBehavior.floating,
    // this.elevation = 6.0,
    // this.margin = const EdgeInsets.all(8.0),
    // this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
  });

  factory ShowSnackInfo.success({required String contentText, Duration? duration}) =>
      ShowSnackInfo._(contentText: contentText, backgroundColor: Colors.green.shade700, duration: duration ?? const Duration(seconds: 4));

  factory ShowSnackInfo.error({required String contentText, Duration? duration}) =>
      ShowSnackInfo._(contentText: contentText, backgroundColor: AppTheme.error, duration: duration ?? const Duration(seconds: 4));

  void show(BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        contentText,
        style: AppTheme.t7LabelLarge(context)?.copyWith(color: AppTheme.onError, letterSpacing: 1.2, fontWeight: FontWeight.bold),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}

SnackBar courseSnackBar(BuildContext context, dynamic courseData) {
  return SnackBar(
    padding: const EdgeInsets.fromLTRB(7.50, 0.0, 10.0, 7.50),
    backgroundColor: Colors.transparent,
    duration: const Duration(milliseconds: 6500),
    dismissDirection: DismissDirection.horizontal,
    content: Card(
      margin: EdgeInsets.zero,
      color: AppTheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              maxLines: 7,
              text: TextSpan(
                children: [
                  const TextSpan(text: "Title : "),
                  TextSpan(
                    text: courseData["Title"].toString(),
                    style: AppTheme.t5TitleMedium(context)?.copyWith(color: AppTheme.onSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                  const TextSpan(text: "\nBy: "),
                  TextSpan(
                    text: courseData["Author"].toString(),
                    style: AppTheme.t5TitleMedium(context)?.copyWith(color: AppTheme.onSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                  const TextSpan(text: "\n\nDescription: "),
                  TextSpan(
                    text: courseData["Description"].toString(),
                    style: AppTheme.t5TitleMedium(context)?.copyWith(color: AppTheme.onSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                ],
                style: AppTheme.t6TitleSmall(context)?.copyWith(color: AppTheme.onSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.0),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                icon: Icon(Icons.close, color: AppTheme.onSecondary),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
