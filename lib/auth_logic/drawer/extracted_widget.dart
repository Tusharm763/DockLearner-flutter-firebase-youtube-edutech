import 'package:flutter/material.dart';
import 'package:page_animation_transition/page_animation_interface.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../core/theme_set/theme_colors.dart';

class DisplayActionMenuForEach extends StatelessWidget {
  final String textToDisplay;
  final StatefulWidget navigateToMaterialPageRoute;
  final PageAnimationInterface transitionMethod;

  const DisplayActionMenuForEach({super.key, required this.textToDisplay, required this.navigateToMaterialPageRoute, required this.transitionMethod});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageAnimationTransition(pageAnimationType: transitionMethod, page: navigateToMaterialPageRoute)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 6.0, 20.0, 6.0),
        child: Card(
          color: AppTheme.sCon,
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(17.50, 15.0, 20.0, 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  maxRadius: 17.5,
                  backgroundColor: AppTheme.primary,
                  child: Text(
                    textToDisplay.substring(0, 1),
                    style: AppTheme.t5TitleMedium(context)!.copyWith(
                      // fontSize: 17.5,
                      color: AppTheme.onSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      textToDisplay,
                      style: AppTheme.t5TitleMedium(context)!.copyWith(color: AppTheme.primary, letterSpacing: 1, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
