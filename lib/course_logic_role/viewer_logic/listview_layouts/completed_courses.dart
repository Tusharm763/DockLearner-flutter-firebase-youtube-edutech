import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../../auth_logic/firebase_controls.dart';
import '../../../core/constants.dart';
import '../../../core/loading_shimmers.dart';
import '../../../core/theme_set/snack_theme.dart';
import '../../../core/theme_set/theme_colors.dart';
import '../page_layouts/completed_course_detail.dart';

class ViewAllCompletedCourses extends StatefulWidget {
  const ViewAllCompletedCourses({super.key});

  @override
  State<ViewAllCompletedCourses> createState() => _ViewAllCompletedCoursesState();
}

class _ViewAllCompletedCoursesState extends State<ViewAllCompletedCourses> {
  ScrollController scrollCon = ScrollController();

  @override
  void initState() {
    super.initState();
  }

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
                padding: const EdgeInsets.only(top: 75.0),
                child: StreamBuilder(
                  stream: FirebaseControls.readCompletedCourse(),
                  builder: (context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? (snapshot.data.docs.length >= 1)
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 2.50),
                                  child: Scrollbar(
                                    trackVisibility: true,
                                    thumbVisibility: true,
                                    thickness: 5.75,
                                    interactive: true,
                                    radius: const Radius.circular(5.0),
                                    controller: scrollCon,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      controller: scrollCon,
                                      physics: const ClampingScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                                      itemCount: snapshot.data.docs.length + 1,
                                      itemBuilder: (context, iterate) {
                                        if (iterate == snapshot.data.docs.length) {
                                          return SizedBox(
                                            width: AppTheme.screenWidthInPortrait(context),
                                            // height: AppTheme.screenWidthInPortrait(context),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width / 2 - 22.50,
                                                      child: Divider(endIndent: 15.0, color: AppTheme.primary, thickness: 2.0),
                                                    ),
                                                    Icon(Icons.info, color: AppTheme.primary),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width / 2 - 22.50,
                                                      child: Divider(indent: 15.0, color: AppTheme.primary, thickness: 2.0),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                Center(
                                                  child: Text(
                                                    "That's All for Now..\nTotal: ${snapshot.data.docs.length} Course(s)...\n",
                                                    textAlign: TextAlign.center,
                                                    style: AppTheme.t6TitleSmall(
                                                      context,
                                                    )!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.50, color: AppTheme.primary),
                                                  ),
                                                ),
                                                Divider(indent: 15.0, endIndent: 15.0, color: AppTheme.primary, thickness: 2.0),
                                                RichText(
                                                  textAlign: TextAlign.justify,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "\n\n\n\n\n\n\n",
                                                        style: AppTheme.t8LabelMedium(
                                                          context,
                                                        )!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onPrimary),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          DocumentSnapshot each = snapshot.data.docs[iterate];
                                          return GestureDetector(
                                            onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(courseSnackBar(context, each)),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width / 2.1,
                                              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: AppTheme.primary),
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(context).size.width / 2.0,
                                                        margin: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              Colors.transparent,
                                                              AppTheme.secondary.withValues(alpha: 0.5),
                                                              AppTheme.secondary,
                                                            ],
                                                            begin: Alignment.topRight,
                                                            end: Alignment.bottomLeft,
                                                          ),
                                                          borderRadius: BorderRadius.circular(15.0),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(16.0),
                                                          child: Stack(
                                                            children: [
                                                              Positioned.fill(
                                                                child: Image.network(
                                                                  getYouTubeThumbnail(each["Id"][0]),
                                                                  fit: BoxFit.cover,
                                                                  loadingBuilder:
                                                                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                                        if (loadingProgress == null) {
                                                                          return child;
                                                                        }
                                                                        return const Center(child: CircularProgressIndicator());
                                                                      },
                                                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                    return Center(
                                                                      child: Icon(Icons.import_contacts, color: AppTheme.onPrimary, size: 62.50),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Positioned.fill(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                      colors: [
                                                                        Colors.transparent,
                                                                        AppTheme.secondary.withValues(alpha: 0.5),
                                                                        AppTheme.secondary,
                                                                      ],
                                                                      begin: Alignment.topCenter,
                                                                      end: Alignment.bottomCenter,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                bottom: 2.50,
                                                                left: 2.50,
                                                                right: 2.50,
                                                                child: GestureDetector(
                                                                  onTap: () async => Navigator.of(context).push(
                                                                    PageAnimationTransition(
                                                                      pageAnimationType: RightToLeftTransition(),
                                                                      page: ViewDetailsCompletedCourses(cTitle: each["Title"]),
                                                                    ),
                                                                  ),
                                                                  child: Card(
                                                                    color: AppTheme.onSecondary,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                                                                      child: Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(right: 2.5),
                                                                              child: SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Text(
                                                                                  each["Title"],
                                                                                  style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                                                    color: AppTheme.primary,
                                                                                    letterSpacing: 1.75,
                                                                                    fontWeight: FontWeight.w800,
                                                                                  ),
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Card(
                                                                            margin: const EdgeInsets.all(2),
                                                                            color: AppTheme.secondary,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.fromLTRB(10.0, 7.5, 10.0, 7.5),
                                                                              child: Text(
                                                                                "View More",
                                                                                style: AppTheme.t6TitleSmall(context)!.copyWith(
                                                                                  color: AppTheme.onSecondary,
                                                                                  letterSpacing: 1.25,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    const SizedBox(height: 50.0),
                                    Text(
                                      "No Courses Found\n",
                                      style: AppTheme.t6TitleSmall(
                                        context,
                                      )!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.50, color: AppTheme.primary),
                                    ),
                                    Divider(indent: 15.0, endIndent: 15.0, color: AppTheme.primary, thickness: 2.0),
                                  ],
                                )
                        : ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              DisplayLoadingHomeScreenCard(),
                              DisplayLoadingHomeScreenCard(),
                              DisplayLoadingHomeScreenCard(),
                              DisplayLoadingHomeScreenCard(),
                            ],
                          );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: AppTheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Note:\n",
                            style: AppTheme.t8LabelMedium(context)!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onPrimary),
                          ),
                          const TextSpan(
                            text:
                                "The Completed Courses are End-to-End Secured, regardless of any Account Deletion. Furthermore, These can not be Deleted, Modified by any Course of Action of Course Instructor.",
                          ),
                        ],
                        style: AppTheme.t9LabelSmall(context)!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) => const AppbarCard(
                  adc: null,
                  titleAppBar: "All Certifications",
                  menu: SizedBox(height: 0, width: 0),
                  menuChildren: SizedBox(height: 0, width: 0),
                  showBackButton: true,
                  showMoreOption: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
