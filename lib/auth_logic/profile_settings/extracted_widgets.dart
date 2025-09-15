import 'package:flutter/material.dart';

import '../../core/theme_set/theme_colors.dart';

class TitleInSettings extends StatelessWidget {
  const TitleInSettings({super.key, required this.textToDisplay});

  final String textToDisplay;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 00.0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsetsDirectional.fromSTEB(00.0, 5.0, 0.0, 05.0),
            child: Text(
              textToDisplay,
              // "Recent Activity...",
              style: AppTheme.t3HeadlineSmall(context)!.copyWith(
                // fontSize: 25.0,
                color: AppTheme.secondary.withValues(alpha: 0.65),
                fontWeight: FontWeight.bold,
                fontSize: AppTheme.t3HeadlineSmall(context)!.fontSize!,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
