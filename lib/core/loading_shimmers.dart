import 'package:dock_learner/core/theme_set/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DisplayLoadingHomeScreenLisTile extends StatelessWidget {
  const DisplayLoadingHomeScreenLisTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.primary.withValues(alpha: 0.7),
      highlightColor: AppTheme.pCon.withValues(alpha: 0.65),
      child: Padding(
        padding: EdgeInsets.zero,
        child: GestureDetector(
          child: const SizedBox(
            width: double.infinity,
            height: 125.0 * 9 / 16,
            child: Padding(
              padding: EdgeInsets.fromLTRB(17.50, 0.0, 17.50, 0.0),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 000.0),
                  child: SizedBox(width: double.infinity),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayLoadingHomeScreenCard extends StatelessWidget {
  const DisplayLoadingHomeScreenCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.primary.withValues(alpha: 0.7),
      highlightColor: AppTheme.pCon.withValues(alpha: 0.65),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7.50, 0.0, 7.50, 10.0),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 5.0,
            color: AppTheme.primary,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17.50))),
            child: SizedBox(height: (MediaQuery.of(context).size.width * 9 / 16) * 0.9, width: (MediaQuery.of(context).size.width * 16 / 9) * 0.9),
          ),
        ),
      ),
    );
  }
}

class DisplayLoadingDetailsHeadingTitle extends StatelessWidget {
  const DisplayLoadingDetailsHeadingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
      child: SizedBox(
        height: 50.0,
        child: Shimmer.fromColors(
          baseColor: AppTheme.primary.withValues(alpha: 0.7),
          highlightColor: AppTheme.pCon.withValues(alpha: 0.65),
          child: Padding(
            padding: EdgeInsets.zero,
            child: GestureDetector(
              child: SizedBox(
                width: double.infinity,
                // height: AppTheme.t5TitleMedium(context)!.fontSize, //125.0 * 9 / 16,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(17.50, 0.0, 17.50, 0.0),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 000.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "",
                          style: AppTheme.t3HeadlineSmall(context)!.copyWith(
                            // fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            fontSize: 0 + AppTheme.t3HeadlineSmall(context)!.fontSize!,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // width: double.infinity, height: 125.0*9/16,
          // title: Text(
          //   'Shimmer',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: 40.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
      ),
    );
  }
}
