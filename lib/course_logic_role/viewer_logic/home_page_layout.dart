import 'package:dock_learner/course_logic_role/viewer_logic/widgets.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../auth_logic/firebase_controls.dart';
import '../../core/data_model/user_data_model.dart';
import '../../core/constants.dart';
import '../../core/home_screen_widgets.dart';
import '../../core/loading_shimmers.dart';
import '../../core/theme_set/theme_colors.dart';
import 'listview_layouts/all_courses.dart';
import 'listview_layouts/current_courses.dart';

class HomeStreamForStudent extends StatelessWidget {
  const HomeStreamForStudent({
    super.key,
    // required this.loadCourseForStudent,
    // required this.allCourseRead,
    // required this.loadCourse,
  });

  // final Stream? loadCourseForStudent;
  // final Stream? allCourseRead;
  // final Stream? loadCourse;

  String getTotalProgressAverage(List<dynamic> progressList, List<dynamic> videoLength) {
    int eachInPercent = 0;
    for (int qq = 0; qq < progressList.length; qq++) {
      if (int.parse(progressList[qq]) != 0) {
        eachInPercent += (int.parse(progressList[qq]) * int.parse(videoLength[qq]));
      }
      debugPrint("$qq at  $eachInPercent with ${(int.parse(progressList[qq]))} * ${int.parse(videoLength[qq])}");
    }
    int totalCourseDuration = 0;
    for (var ii in videoLength) {
      totalCourseDuration += int.parse(ii);
    }
    debugPrint(totalCourseDuration.toString());
    return (eachInPercent / totalCourseDuration).round().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (BuildContext context) {
            try {
              return Column(
                children: [
                  Row(children: [TitleInHomeScreen(textToDisplay: "Recent Activity...")]),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: StreamBuilder(
                          stream: FirebaseControls.readCurrentCourse(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              debugPrint(snapshot.data.docs.toString());
                              debugPrint(snapshot.data.docs.length.toString());
                            }
                            return (snapshot.hasData)
                                ? (snapshot.data.docs.length < 1)
                                      ? InkWell(
                                          onTap: () => Navigator.of(context).push(
                                            PageAnimationTransition(
                                              pageAnimationType: RightToLeftTransition(),
                                              page: const ViewCoursesFromFirebaseDB(),
                                            ),
                                          ),
                                          child: Center(
                                            child: SizedBox(
                                              width: AppTheme.screenWidthInPortrait(context),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(
                                                      "No Recent Courses...Add Course",
                                                      style: AppTheme.t6TitleSmall(
                                                        context,
                                                      )!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.50, color: AppTheme.primary),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : StreamBuilder(
                                          stream: FirebaseControls.readRecentCourse(),
                                          builder: (context, recentQuery) {
                                            if (recentQuery.hasData) {
                                              try {
                                                List<dynamic> recent = recentQuery.data!.docs[0]["Recents"];
                                                return ListTileForRecentCourse(
                                                  snapshot: snapshot,
                                                  recentList: recent,
                                                  currentIndex: 0,
                                                  bgColor: bgColor,
                                                );
                                              } catch (e) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      PageAnimationTransition(
                                                        pageAnimationType: RightToLeftTransition(),
                                                        page: const ViewCoursesFromFirebaseDB(),
                                                      ),
                                                    );
                                                  },
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: AppTheme.screenWidthInPortrait(context),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Text(
                                                              "No Recent Courses...Add Course",
                                                              // (roleHive == "Student")?
                                                              // "If You haven't Started Any Course Right Now..." //Nothing to Show...Start Learning..."
                                                              // : "No Courses to Show...",
                                                              style: AppTheme.t6TitleSmall(context)!.copyWith(
                                                                // fontSize: 17.5,
                                                                fontWeight: FontWeight.bold,
                                                                letterSpacing: 2.50,
                                                                // fontSize: AppTheme.t5TitleMedium(context)!.fontSize! + 2.5,
                                                                color: AppTheme.primary,
                                                                // color: Colors.blueGrey.shade800,
                                                              ),
                                                            ),
                                                          ),
                                                          // Padding(
                                                          //   padding: const EdgeInsets.symmetric(horizontal: 62.50),
                                                          //   child: Text(
                                                          //     // (roleHive == "Student")?
                                                          //     "Add a Course to Start Learning a New Skills and Development.\nClick to add New Course."
                                                          //     // : "Once you will Add a Course...\nYou can Organise them.",
                                                          //     ,
                                                          //     textAlign: TextAlign.center,
                                                          //     style: AppTheme.t7LabelLarge(context)!.copyWith(
                                                          //       // fontSize: 17.5,
                                                          //       fontWeight: FontWeight.w700,
                                                          //       letterSpacing: 1.25,
                                                          //       color: AppTheme.secondary,
                                                          //       // color: Colors.blueGrey.shade800,
                                                          //     ),
                                                          //     // style: TextStyle(
                                                          //     //   fontSize: 14.0,
                                                          //     //   fontWeight: FontWeight.w500,
                                                          //     //   color: Colors.blueGrey.shade700,
                                                          //     // ),
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                            return const DisplayLoadingHomeScreenLisTile();
                                          },
                                        )
                                : const DisplayLoadingHomeScreenLisTile();
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const TitleInHomeScreen(textToDisplay: "My Courses..."),
                      StreamBuilder(
                        //T.O.D.O: Stream for CONTINUE LEARNING
                        stream: FirebaseControls.readCurrentCourse(),
                        builder: (context, AsyncSnapshot snapshot) {
                          return (snapshot.hasData)
                              ? (snapshot.data.docs.length > 0)
                                    ? GestureDetector(
                                        onTap: () async => Navigator.of(context).push(
                                          PageAnimationTransition(
                                            page: const ResumeViewForEachCourseDetailsStudents(),
                                            pageAnimationType: RightToLeftTransition(),
                                          ),
                                        ),
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          margin: const EdgeInsetsDirectional.fromSTEB(2.50, 20.0, 20.0, 20.0),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                                            color: AppTheme.primary,
                                          ),
                                          child: Icon(Icons.arrow_forward, size: 25.0, color: AppTheme.onPrimary),
                                        ),
                                      )
                                    : const SizedBox(width: 0.0, height: 0.0)
                              : const SizedBox(height: 45.0, width: 45.0);
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: StreamBuilder(
                          stream: FirebaseControls.readCurrentCourse(),
                          builder: (context, AsyncSnapshot snapshot) {
                            return (snapshot.hasData)
                                ? (snapshot.data.docs.length > 0)
                                      ? (snapshot.data.docs.length > 1)
                                            ? Column(
                                                children: [
                                                  (snapshot.data.docs.length >= 2)
                                                      ? StreamBuilder(
                                                          stream: FirebaseControls.readRecentCourse(),
                                                          builder: (context, recentQuery) {
                                                            List<dynamic> recent;
                                                            if (recentQuery.hasData) {
                                                              try {
                                                                recent = recentQuery.data!.docs[0]["Recents"];
                                                                return ListTileForRecentCourse(
                                                                  snapshot: snapshot,
                                                                  recentList: recent,
                                                                  currentIndex: 1,
                                                                  bgColor: bgColor,
                                                                );
                                                              } catch (e) {
                                                                debugPrint(e.toString());
                                                                return const SizedBox.shrink();
                                                              }
                                                            }
                                                            return const DisplayLoadingHomeScreenLisTile();
                                                          },
                                                        )
                                                      : const SizedBox(height: 0.0, width: 0.0),
                                                  (snapshot.data.docs.length >= 3)
                                                      ? Padding(
                                                          padding: const EdgeInsets.only(top: 12.50),
                                                          child: StreamBuilder(
                                                            stream: FirebaseControls.readRecentCourse(),
                                                            builder: (context, recentQuery) {
                                                              List<dynamic> recent;
                                                              if (recentQuery.hasData) {
                                                                try {
                                                                  recent = recentQuery.data!.docs[0]["Recents"];
                                                                  return ListTileForRecentCourse(
                                                                    snapshot: snapshot,
                                                                    recentList: recent,
                                                                    currentIndex: 2,
                                                                    bgColor: bgColor,
                                                                  );
                                                                } catch (e) {
                                                                  return const SizedBox.shrink();
                                                                }
                                                              }

                                                              return const DisplayLoadingHomeScreenLisTile();
                                                            },
                                                          ),
                                                        )
                                                      : const SizedBox(height: 0.0, width: 0.0),
                                                  (snapshot.data.docs.length >= 4)
                                                      ? Padding(
                                                          padding: const EdgeInsets.only(top: 12.50),
                                                          child: StreamBuilder(
                                                            stream: FirebaseControls.readRecentCourse(),
                                                            builder: (context, recentQuery) {
                                                              List<dynamic> recent;
                                                              if (recentQuery.hasData) {
                                                                try {
                                                                  recent = recentQuery.data!.docs[0]["Recents"];
                                                                  return ListTileForRecentCourse(
                                                                    snapshot: snapshot,
                                                                    recentList: recent,
                                                                    currentIndex: 3,
                                                                    bgColor: bgColor,
                                                                  );
                                                                } catch (e) {
                                                                  return const SizedBox.shrink();
                                                                }
                                                              }
                                                              return const DisplayLoadingHomeScreenLisTile();
                                                              // ); return const SizedBox(
                                                              //   height: 0.0,
                                                              //   width: 0.0,
                                                              // );
                                                            },
                                                          ),
                                                        )
                                                      : const SizedBox(height: 0.0, width: 0.0),
                                                ],
                                              )
                                            : const SizedBox.shrink()
                                      : InkWell(
                                          onTap: () => Navigator.of(context).push(
                                            PageAnimationTransition(
                                              pageAnimationType: RightToLeftTransition(),
                                              page: const ViewCoursesFromFirebaseDB(),
                                            ),
                                          ),
                                          child: Center(
                                            child: SizedBox(
                                              width: AppTheme.screenWidthInPortrait(context),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 62.50),
                                                    child: Text(
                                                      "Add a Course to Start Learning a New Skills and Development.",
                                                      textAlign: TextAlign.center,
                                                      style: AppTheme.t6TitleSmall(
                                                        context,
                                                      )!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.25, color: AppTheme.primary),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                      ),
                    ],
                  ),
                ],
              );
            } catch (e) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.50),
                child: Center(
                  child: Text(
                    "\nSomething Went Wrong...Please Re-Start the App.\nCouldn't Find the Authentication Channel User.",
                    textAlign: TextAlign.center,
                    style: AppTheme.t8LabelMedium(context)!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.25, color: AppTheme.primary),
                  ),
                ),
              );
            }
          },
        ),
        Row(
          children: [
            const TitleInHomeScreen(textToDisplay: "All Other Courses..."),
            StreamBuilder(
              //T.O.D.O.: Stream for CONTINUE LEARNING
              stream: FirebaseControls.readCurrentCourse(),
              builder: (context, AsyncSnapshot snapshot) {
                return (snapshot.hasData)
                    ? (snapshot.data.docs.length > 0)
                          ? GestureDetector(
                              onTap: () async => Navigator.of(
                                context,
                              ).push(PageAnimationTransition(page: const ViewCoursesFromFirebaseDB(), pageAnimationType: RightToLeftTransition())),
                              child: Container(
                                height: 45,
                                width: 45,
                                margin: const EdgeInsetsDirectional.fromSTEB(2.50, 20.0, 20.0, 20.0),
                                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(15)), color: AppTheme.primary),
                                child: Icon(Icons.arrow_forward, size: 25.0, color: AppTheme.onPrimary),
                              ),
                            )
                          : const SizedBox(width: 0.0, height: 0.0)
                    : const SizedBox(height: 45.0, width: 45.0);
              },
            ),
          ],
        ),
        // T.O.D.O.:Card for 5 all Courses
        Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: StreamBuilder(
              //T.O.D.O.: Stream for ALL COURSES
              stream: FirebaseControls.readAllCourse(),
              builder: (context, AsyncSnapshot dataQueries) {
                List<int> iterationIndex = List.empty(growable: true);
                int iterationForAllCourseIndex = 0;
                if (dataQueries.hasData) {
                  for (dynamic i in dataQueries.data.docs) {
                    if (iterationIndex.length >= 6) {
                      break;
                    }
                    bool isNameInUser = false;
                    for (var name in i["Users"]) {
                      if (name.toString() == UserData.googleUserName) {
                        isNameInUser = true;
                        break;
                      }
                    }
                    if (!isNameInUser) {
                      iterationIndex.add(iterationForAllCourseIndex);
                    }
                    iterationForAllCourseIndex++;
                  }
                }
                return dataQueries.hasData
                    ? Column(
                        children: [
                          (dataQueries.data.docs.length > 1 && iterationIndex.length > 1)
                              ? RenderCardLikeForAllCourseView(
                                  bgColor: bgColor,
                                  indexOfCourse: iterationIndex[0],
                                  data: dataQueries.data.docs,
                                  courseTitle: dataQueries.data.docs[iterationIndex[0]]["Title"],
                                )
                              : const Text("No courses Found."),
                          (dataQueries.data.docs.length > 2 && iterationIndex.length > 2)
                              ? RenderCardLikeForAllCourseView(
                                  bgColor: bgColor,
                                  indexOfCourse: iterationIndex[01],
                                  data: dataQueries.data.docs,
                                  courseTitle: dataQueries.data.docs[iterationIndex[01]]["Title"],
                                )
                              : Container(),
                          (dataQueries.data.docs.length > 3 && iterationIndex.length > 3)
                              ? RenderCardLikeForAllCourseView(
                                  bgColor: bgColor,
                                  indexOfCourse: iterationIndex[02],
                                  data: dataQueries.data.docs,
                                  courseTitle: dataQueries.data.docs[iterationIndex[02]]["Title"],
                                )
                              : Container(),
                          (dataQueries.data.docs.length > 4 && iterationIndex.length > 4)
                              ? RenderCardLikeForAllCourseView(
                                  bgColor: bgColor,
                                  indexOfCourse: iterationIndex[03],
                                  data: dataQueries.data.docs,
                                  courseTitle: dataQueries.data.docs[iterationIndex[03]]["Title"],
                                )
                              : Container(),
                          (dataQueries.data.docs.length > 5 && iterationIndex.length > 5)
                              ? RenderCardLikeForAllCourseView(
                                  bgColor: bgColor,
                                  indexOfCourse: iterationIndex[04],
                                  data: dataQueries.data.docs,
                                  courseTitle: dataQueries.data.docs[iterationIndex[04]]["Title"],
                                )
                              : Container(),
                          (dataQueries.data.docs.length > 0)
                              ? Padding(
                                  padding: const EdgeInsets.fromLTRB(7.50, 10.0, 7.50, 10.0),
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).push(
                                      PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const ViewCoursesFromFirebaseDB()),
                                    ),
                                    child: Card(
                                      elevation: 5,
                                      color: AppTheme.primary,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                                          child: Text(
                                            "View All Courses",
                                            style: AppTheme.t5TitleMedium(
                                              context,
                                            )!.copyWith(color: AppTheme.onPrimary, fontWeight: FontWeight.w700, letterSpacing: 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : const Column(children: [DisplayLoadingHomeScreenCard(), DisplayLoadingHomeScreenCard()]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
