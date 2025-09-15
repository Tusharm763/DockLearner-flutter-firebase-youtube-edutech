import 'package:flutter/material.dart';

import '../../../../core/theme_set/theme_colors.dart';
import 'create_course.dart';

class CardForHelpTag extends StatelessWidget {
  const CardForHelpTag({super.key, required this.primaryText, required this.secondaryText});

  final String primaryText;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 8.0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 5.0,
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            const SizedBox(height: 10.00),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  primaryText,
                  style: AppTheme.t5TitleMedium(
                    context,
                  )?.copyWith(fontWeight: FontWeight.bold, fontFamily: 'SourGummy', letterSpacing: 01.5, color: AppTheme.onPrimary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: Text(
                secondaryText,
                style: AppTheme.t6TitleSmall(context)?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourGummy',
                  letterSpacing: 01.5,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 10.00),
          ],
        ),
      ),
    );
  }
}

class ViewMoreInformationForAddingCourse extends StatefulWidget {
  const ViewMoreInformationForAddingCourse({super.key});

  @override
  State<ViewMoreInformationForAddingCourse> createState() => _ViewMoreInformationForAddingCourseState();
}

class _ViewMoreInformationForAddingCourseState extends State<ViewMoreInformationForAddingCourse> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        backgroundColor: AppTheme.pCon,
        body: SafeArea(
          child: Stack(
            children: [
              const BackGroundWithGradientEffect(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 75.0, 10.0, 0.0),
                child: ListView(
                  children: [
                    CardForHelpTag(primaryText: cardText1[0].toString(), secondaryText: cardText1[2].toString()),
                    CardForHelpTag(primaryText: cardText2[0].toString(), secondaryText: cardText2[2].toString()),
                    CardForHelpTag(primaryText: cardText3[0].toString(), secondaryText: cardText3[2].toString()),
                    const CardForHelpTag(
                      primaryText: "Part-wise:\nTitle of each Section",
                      secondaryText: "The Title of the Current Course Step, for Student's Conveniences to recognise every Part in Short.",
                    ),
                    const CardForHelpTag(
                      primaryText: "Part-wise:\nYoutube U.R.L. for Section",
                      secondaryText:
                          "The U.R.L. of the Part's Youtube Videos. Just Copy-Paste the Url from any browser. Make sure that the Video U.R.L. is able to be Play Video in the Browser.\n\nNote: This needs to be Verified Strictly. If a Video is able to be streamed in any Browser, that U.R.L. will be considered as Valid. Else the Video U.R.L. is Wrongly Submitted.",
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  return const AppbarCard(
                    adc: null,
                    titleAppBar: "Help",
                    menu: SizedBox(height: 0, width: 0),
                    menuChildren: SizedBox(height: 0, width: 0),
                    showBackButton: true,
                    showMoreOption: false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
