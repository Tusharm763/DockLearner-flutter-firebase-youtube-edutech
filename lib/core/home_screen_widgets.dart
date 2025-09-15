import 'package:dock_learner/core/theme_set/theme_colors.dart';
import 'package:flutter/material.dart';

class TitleInHomeScreen extends StatelessWidget {
  const TitleInHomeScreen({super.key, required this.textToDisplay});

  final String textToDisplay;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsetsDirectional.fromSTEB(00.0, 10.0, 20.0, 10.0),
            child: Text(
              textToDisplay,
              style: AppTheme.t3HeadlineSmall(context)!.copyWith(
                color: AppTheme.secondary.withValues(alpha: 0.65), // Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
                fontSize: 0 + AppTheme.t3HeadlineSmall(context)!.fontSize!,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleDetails extends StatelessWidget {
  const TitleDetails({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Card(
        color: AppTheme.primary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: AppTheme.t4TitleLarge(context)!.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppTheme.onPrimary,
                fontSize: -2.0 + AppTheme.t4TitleLarge(context)!.fontSize!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
