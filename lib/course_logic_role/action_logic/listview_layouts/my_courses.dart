import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'dart:async';
import '../../../auth_logic/firebase_controls.dart';
import '../../../core/data_model/user_data_model.dart';
import '../../../core/constants.dart';
import '../../../core/loading_shimmers.dart';
import '../../../core/theme_set/snack_theme.dart';
import '../../../core/theme_set/theme_colors.dart';
import '../course_controls/create/create_course.dart';
import '../page_layouts/view_course_details.dart';

class ViewOrganizingMyCoursesDetails extends StatefulWidget {
  const ViewOrganizingMyCoursesDetails({super.key});

  @override
  State<ViewOrganizingMyCoursesDetails> createState() => _ViewOrganizingMyCoursesDetailsState();
}

class _ViewOrganizingMyCoursesDetailsState extends State<ViewOrganizingMyCoursesDetails> {
  // Stream? loadCourse;
  ScrollController scrollCon = ScrollController();

  // void loadOrRefreshFromDataBase() => loadCourse = FirebaseFirestore.instance.collection("CourseDB").snapshots();

  @override
  void initState() {
    // loadOrRefreshFromDataBase();
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
                  stream: FirebaseControls.readAllCourse(),
                  builder: (context, AsyncSnapshot snapshot) {
                    int numberOfCoursesFromAuthor = 0;
                    if (snapshot.hasData) {
                      for (var iii in snapshot.data.docs) {
                        if (iii["Author"] == UserData.googleUserName) {
                          numberOfCoursesFromAuthor++;
                        }
                      }
                    }
                    return snapshot.hasData
                        ? (numberOfCoursesFromAuthor >= 1)
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
                                      controller: scrollCon,
                                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                                      itemCount: snapshot.data.docs.length + 1,
                                      itemBuilder: (context, iterate) {
                                        if (iterate == snapshot.data.docs.length) {
                                          return GestureDetector(
                                            onTap: () => Navigator.of(context).push(
                                              PageAnimationTransition(
                                                page: const AddCourseToCloudDatabase(),
                                                pageAnimationType: RightToLeftTransition(),
                                              ),
                                            ),
                                            child: SizedBox(
                                              width: AppTheme.screenWidthInPortrait(context),
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
                                                      "That's All for Now..\nTotal: $numberOfCoursesFromAuthor Courses\nClick to Add More Courses...\n",
                                                      textAlign: TextAlign.center,
                                                      style: AppTheme.t6TitleSmall(
                                                        context,
                                                      )!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.50, color: AppTheme.primary),
                                                    ),
                                                  ),
                                                  // Divider(
                                                  //   indent: 15.0,
                                                  //   endIndent: 15.0,
                                                  //   color: AppTheme.primary,
                                                  //   thickness: 2.0,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          DocumentSnapshot eachInListView = snapshot.data.docs[iterate];
                                          try {
                                            return (eachInListView["Author"] == UserData.googleUserName)
                                                ? GestureDetector(
                                                    onLongPress: () =>
                                                        ScaffoldMessenger.of(context).showSnackBar(courseSnackBar(context, eachInListView)),
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
                                                                          getYouTubeThumbnail(eachInListView["Id"][0]),
                                                                          fit: BoxFit.cover,
                                                                          loadingBuilder:
                                                                              (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                                                if (loadingProgress == null) {
                                                                                  return child;
                                                                                }
                                                                                return const Center(child: CircularProgressIndicator());
                                                                              },
                                                                          errorBuilder:
                                                                              (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                return Center(
                                                                                  child: Icon(
                                                                                    Icons.import_contacts,
                                                                                    color: AppTheme.onPrimary,
                                                                                    size: 62.50,
                                                                                  ),
                                                                                );
                                                                              },
                                                                        ),
                                                                      ),
                                                                      Positioned.fill(
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              colors: [Colors.transparent, AppTheme.secondary],
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
                                                                          onTap: () => Navigator.of(context).push(
                                                                            PageAnimationTransition(
                                                                              pageAnimationType: RightToLeftTransition(),
                                                                              page: ViewEachForCourseOrganiser(courseData: eachInListView),
                                                                            ),
                                                                          ),
                                                                          child: Card(
                                                                            color: AppTheme.onSecondary, // Colors.blueGrey.shade100,
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
                                                                                          eachInListView["Title"],
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
                                                                                      padding: const EdgeInsets.all(7.50),
                                                                                      child: Text(
                                                                                        "Manage",
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
                                                  )
                                                : const SizedBox(height: 0.0, width: 0.0);
                                          } catch (e) {
                                            return const SizedBox.shrink();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () => Navigator.of(
                                    context,
                                  ).push(PageAnimationTransition(page: const AddCourseToCloudDatabase(), pageAnimationType: RightToLeftTransition())),
                                  child: SizedBox(
                                    width: AppTheme.screenWidthInPortrait(context),
                                    height: AppTheme.screenHeightInPortrait(context),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const SizedBox(height: 50.0),
                                        Text(
                                          "No Courses Found\nClick to Add Courses Now...\n",
                                          style: AppTheme.t6TitleSmall(
                                            context,
                                          )!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.50, color: AppTheme.primary),
                                        ),
                                        Divider(indent: 15.0, endIndent: 15.0, color: AppTheme.primary, thickness: 2.0),
                                      ],
                                    ),
                                  ),
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
              Builder(
                builder: (context) => const AppbarCard(
                  adc: null,
                  titleAppBar: "Organise My Courses",
                  menu: SizedBox(height: 0.0, width: 0.0),
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
