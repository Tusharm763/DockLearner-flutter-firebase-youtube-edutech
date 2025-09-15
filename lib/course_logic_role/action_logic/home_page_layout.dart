import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dock_learner/course_logic_role/action_logic/widgets.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../auth_logic/firebase_controls.dart';
import '../../core/data_model/user_data_model.dart';
import '../../core/constants.dart';
import '../../core/home_screen_widgets.dart';
import '../../core/loading_shimmers.dart';
import '../../core/theme_set/theme_colors.dart';
import 'course_controls/create/create_course.dart';
import 'listview_layouts/all_courses.dart';
import 'listview_layouts/my_courses.dart';

class HomeStreamForCourseOrganiser extends StatefulWidget {
  const HomeStreamForCourseOrganiser({
    super.key,

    // required this.loadCourseForStudent,
    // required this.allCourseRead,
    // required this.loadCourse,
  });

  // final Stream? loadCourseForStudent;
  // final Stream? allCourseRead;
  // final Stream? loadCourse;

  @override
  State<HomeStreamForCourseOrganiser> createState() => _HomeStreamForCourseOrganiserState();
}

class _HomeStreamForCourseOrganiserState extends State<HomeStreamForCourseOrganiser> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
          stream: FirebaseControls.readAllCourse(),
          builder: (context, AsyncSnapshot snapshot) {
            return (snapshot.hasData)
                ? GestureDetector(
                    onTap: () => setState(
                      () => Navigator.of(
                        context,
                      ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const AddCourseToCloudDatabase())),
                    ),
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                      color: AppTheme.primary,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsetsDirectional.fromSTEB(12.5, 12.5, 5, 12.5),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "Add New Course...",
                                  style: AppTheme.t4TitleLarge(
                                    context,
                                  )!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onPrimary, letterSpacing: 1.5),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 45,
                            width: 45,
                            margin: const EdgeInsetsDirectional.fromSTEB(0.0, 12.5, 12.5, 12.5),
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(12.5)), color: AppTheme.onPrimary),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [Icon(Icons.add, size: 25.0, color: AppTheme.primary)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Padding(padding: EdgeInsets.only(top: 12.50), child: DisplayLoadingHomeScreenLisTile());
          },
        ),
        Row(
          children: [
            const TitleInHomeScreen(textToDisplay: "Organise Courses..."),
            GestureDetector(
              onTap: () => Navigator.of(
                context,
              ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const ViewOrganizingMyCoursesDetails())),
              child: Container(
                height: 45,
                width: 45,
                margin: const EdgeInsetsDirectional.fromSTEB(2.50, 20.0, 20.0, 20.0),
                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(15)), color: AppTheme.primary),
                child: Icon(Icons.arrow_forward, size: 25.0, color: AppTheme.onPrimary),
              ),
            ),
          ],
        ),
        StreamBuilder(
          stream: FirebaseControls.readAllCourse(),
          builder: (context, AsyncSnapshot snapshot) {
            return (snapshot.hasData)
                ? SizedBox(
                    child: Builder(
                      builder: (context) {
                        List<int> iterationIndex = List.empty(growable: true);
                        int indexForAuthorCourses = 0;
                        for (dynamic i in snapshot.data.docs) {
                          if (iterationIndex.length >= 6) {
                            break;
                          }
                          if (i["Author"] == UserData.googleUserName) {
                            iterationIndex.add(indexForAuthorCourses);
                          }
                          indexForAuthorCourses++;
                        }
                        return Column(
                          children: [
                            (iterationIndex.isNotEmpty)
                                ? RenderListTileForOrganisingMyCourses(snapshot: snapshot, currentIndex: iterationIndex[0], bgColor: bgColor)
                                : const SizedBox(height: 0.0, width: 0.0),
                            const SizedBox(height: 10.0, width: 0.0),
                            (iterationIndex.length >= 2)
                                ? RenderListTileForOrganisingMyCourses(snapshot: snapshot, currentIndex: iterationIndex[1], bgColor: bgColor)
                                : const SizedBox(height: 0.0, width: 0.0),
                            const SizedBox(height: 10.0, width: 0.0),
                            (iterationIndex.length >= 3)
                                ? RenderListTileForOrganisingMyCourses(snapshot: snapshot, currentIndex: iterationIndex[2], bgColor: bgColor)
                                : const SizedBox(height: 0.0, width: 0.0),
                          ],
                        );
                      },
                    ),
                  )
                : const Column(
                    children: [
                      DisplayLoadingHomeScreenLisTile(),
                      Padding(padding: EdgeInsets.only(top: 12.50), child: DisplayLoadingHomeScreenLisTile()),
                      Padding(padding: EdgeInsets.only(top: 12.50), child: DisplayLoadingHomeScreenLisTile()),
                    ],
                  );
          },
        ),
        Row(
          children: [
            const TitleInHomeScreen(textToDisplay: "All Other Courses..."),
            GestureDetector(
              onTap: () => Navigator.of(
                context,
              ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const ViewOrganizingAllCoursesDetails())),
              child: Container(
                height: 45,
                width: 45,
                margin: const EdgeInsetsDirectional.fromSTEB(2.50, 20.0, 20.0, 20.0),
                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(15)), color: AppTheme.primary),
                child: Icon(Icons.arrow_forward, size: 25.0, color: AppTheme.onPrimary),
              ),
            ),
          ],
        ),
        StreamBuilder(
          stream: FirebaseControls.readAllCourse(),
          builder: (context, AsyncSnapshot snapshot) {
            return (snapshot.hasData)
                ? SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data.docs.length < 5) ? snapshot.data.docs.length : 5,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, indexListViewBuilder) {
                        DocumentSnapshot each = snapshot.data.docs[indexListViewBuilder];
                        return (each["Author"] != UserData.googleUserName)
                            ? RenderCardForCourseOrganiserLikeForAllCourseView(
                                bgColor: bgColor,
                                data: snapshot.data.docs,
                                courseTitle: snapshot.data.docs[indexListViewBuilder]["Title"],
                                indexOfCourse: indexListViewBuilder,
                              )
                            : const SizedBox(height: 0.0, width: 0.0);
                      },
                    ),
                  )
                : const Column(children: [DisplayLoadingHomeScreenCard(), DisplayLoadingHomeScreenCard()]);
          },
        ),
      ],
    );
  }
}
