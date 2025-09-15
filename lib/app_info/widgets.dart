import 'package:flutter/material.dart';

import '../core/theme_set/theme_colors.dart';

class CardExpansionForEach extends StatelessWidget {
  const CardExpansionForEach({super.key, required this.textP, required this.content, required this.iconsData});

  final String textP;
  final String content;
  final IconData iconsData;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 6.0),
      color: AppTheme.primary,
      elevation: 5.0,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ExpansionTile(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          iconColor: AppTheme.onPrimary,
          textColor: AppTheme.primary,
          backgroundColor: AppTheme.primary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
          title: Text(
            textP,
            style: AppTheme.t5TitleMedium(context)!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onPrimary, letterSpacing: 1.4),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SizedBox(height: 30.0, width: 30.0, child: Icon(iconsData, color: AppTheme.onPrimary)),
          ),
          trailing: Icon(
            Icons.navigate_next,
            size: 0, //27.5,
            color: AppTheme.onPrimary,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
              child: Card(
                color: AppTheme.pCon,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: content,
                      style: AppTheme.t7LabelLarge(context)!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary, letterSpacing: 1.4),
                    ),
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
