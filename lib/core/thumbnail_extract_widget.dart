import 'package:dock_learner/core/theme_set/theme_colors.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class DetailsThumbNail extends StatelessWidget {
  const DetailsThumbNail({super.key, required this.textURL});

  final String textURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 2.0,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: AppTheme.primary),
        gradient: LinearGradient(
          colors: [AppTheme.secondary.withValues(alpha: 0.65), AppTheme.primary.withValues(alpha: 0.8), AppTheme.secondary.withValues(alpha: 0.65)],
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                getYouTubeThumbnail(textURL),
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.secondary.withValues(alpha: 0.65),
                          AppTheme.primary.withValues(alpha: 0.8),
                          AppTheme.secondary.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                    child: const CircularProgressIndicator(),
                  );
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.secondary.withValues(alpha: 0.65),
                          AppTheme.primary.withValues(alpha: 0.8),
                          AppTheme.secondary.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                    child: Icon(Icons.import_contacts, size: 45.0, color: AppTheme.onPrimary.withValues(alpha: 0.4)),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.65),
                      AppTheme.primary.withValues(alpha: 0.0),
                      AppTheme.secondary.withValues(alpha: 0.65),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
