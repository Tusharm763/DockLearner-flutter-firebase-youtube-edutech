import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dock_learner/auth_logic/firebase_controls.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../../core/constants.dart';
import '../../../core/loading_shimmers.dart';
import '../../../core/theme_set/snack_theme.dart';
import '../../../core/theme_set/theme_colors.dart';
import '../page_layouts/completed_course_detail.dart';
import '../page_layouts/enrolled_course_details.dart';
import 'all_courses.dart';

String getTotalProgressAverage(List<dynamic> progressList, List<dynamic> videoLength) {
  int eachInPercent = 0;
  for (int qq = 0; qq < progressList.length; qq++) {
    if (int.parse(progressList[qq] == "" ? "0" : progressList[qq]) != 0) {
      eachInPercent += (int.parse(progressList[qq]) * int.parse(videoLength[qq]));
    }
    debugPrint("$qq at  $eachInPercent with ${(int.parse(progressList[qq] == "" ? "0" : progressList[qq]))} * ${int.parse(videoLength[qq])}");
  }
  int totalCourseDuration = 0;
  for (var ii in videoLength) {
    totalCourseDuration += int.parse(ii);
  }
  debugPrint(totalCourseDuration.toString());
  return (eachInPercent / totalCourseDuration).round().toString();
}

class ResumeViewForEachCourseDetailsStudents extends StatefulWidget {
  const ResumeViewForEachCourseDetailsStudents({super.key});

  @override
  State<ResumeViewForEachCourseDetailsStudents> createState() => _ResumeViewForEachCourseDetailsStudentsState();
}

class _ResumeViewForEachCourseDetailsStudentsState extends State<ResumeViewForEachCourseDetailsStudents> {
  bool searchCourseMode = false;
  ScrollController scrollCon = ScrollController();
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollCon.dispose();
    searchTextController.dispose();
    super.dispose();
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
                padding: EdgeInsets.only(top: searchCourseMode ? 75.0 + 75.0 + 10.0 : 75.0),
                child: StreamBuilder(
                  stream: FirebaseControls.readCurrentCourse(),
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
                                      controller: scrollCon,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 7.50),
                                      itemCount: snapshot.data.docs.length + 1 + 1,
                                      itemBuilder: (context, iterateWithTwo) {
                                        if (iterateWithTwo == snapshot.data.docs.length + 1) {
                                          return Builder(
                                            builder: (context) {
                                              int searchResultCount = 0;
                                              if (searchCourseMode) {
                                                if (searchTextController.text.isNotEmpty) {
                                                  for (DocumentSnapshot i in snapshot.data.docs) {
                                                    if (i["Title"].toString().trim().toUpperCase().contains(
                                                      searchTextController.text.toString().toUpperCase(),
                                                    )) {
                                                      searchResultCount++;
                                                    }
                                                  }
                                                }
                                              }
                                              return SizedBox(
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
                                                        searchCourseMode && searchTextController.text.isNotEmpty
                                                            ? "That's All for Now..\nSearch Result: $searchResultCount / ${snapshot.data.docs.length} Courses...\n"
                                                            : "That's All for Now..\nTotal: ${snapshot.data.docs.length} Courses...\n",
                                                        textAlign: TextAlign.center,
                                                        style: AppTheme.t6TitleSmall(
                                                          context,
                                                        )!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.50, color: AppTheme.primary),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        } else if (iterateWithTwo == 0) {
                                          return Visibility(
                                            visible: (searchCourseMode && false),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width / 2.1,
                                              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: AppTheme.primary),
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              child: ClipRRect(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 12.0, right: 15.0, top: 8.0, bottom: 8.0),
                                                  child: TextFormField(
                                                    controller: searchTextController,
                                                    textInputAction: TextInputAction.done,
                                                    keyboardType: TextInputType.text,
                                                    autocorrect: false,
                                                    textCapitalization: TextCapitalization.none,
                                                    style: CustomStyleForTextFormField.formFieldTextStyle(context),
                                                    decoration: CustomStyleForTextFormField.formFieldDecoration(
                                                      context,
                                                      Icons.search,
                                                      "Search from My Courses",
                                                    ),
                                                    onChanged: (t) => setState(() => debugPrint("Search Query Changed")),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          int iterate = iterateWithTwo - 1;
                                          DocumentSnapshot eachInListView = snapshot.data.docs[iterate];
                                          if (searchCourseMode) {
                                            if (searchTextController.text.isNotEmpty) {
                                              if (false ==
                                                  (eachInListView["Title"].toString().trim().toUpperCase().contains(
                                                    searchTextController.text.toString().toUpperCase(),
                                                  ))) {
                                                return const SizedBox.shrink();
                                              }
                                            }
                                          }
                                          try {
                                            return GestureDetector(
                                              onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(courseSnackBar(context, eachInListView)),
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
                                                                    onTap: () async {
                                                                      bool isCompleted = true;
                                                                      for (var i in eachInListView["Progress"]) {
                                                                        if (i.toString() != "100") {
                                                                          isCompleted = false;
                                                                          break;
                                                                        }
                                                                      }
                                                                      Navigator.of(context).push(
                                                                        PageAnimationTransition(
                                                                          pageAnimationType: RightToLeftTransition(),
                                                                          page: (isCompleted)
                                                                              ? ViewDetailsCompletedCourses(cTitle: eachInListView["Title"])
                                                                              : ViewEachForStudent(
                                                                                  courseData: {
                                                                                    "Title": eachInListView["Title"],
                                                                                    "Description": eachInListView["Description"],
                                                                                    "Author": eachInListView["Author"],
                                                                                    "Id": eachInListView["Id"],
                                                                                    "Length": eachInListView["Length"],
                                                                                    "Progress": eachInListView["Progress"],
                                                                                  },
                                                                                ),
                                                                        ),
                                                                      );
                                                                    },
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
                                                                                  "Resume",
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
                                          } catch (e) {
                                            return const SizedBox.shrink();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    PageAnimationTransition(page: const ViewCoursesFromFirebaseDB(), pageAnimationType: RightToLeftTransition()),
                                  ),
                                  child: SizedBox(
                                    width: AppTheme.screenWidthInPortrait(context),
                                    height: AppTheme.screenHeightInPortrait(context),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const SizedBox(height: 50.0),
                                        Text(
                                          "No Enrolled Courses Found\nClick to Add Courses Now...\n",
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
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 75.0, 10.0, 0.0),
                child: Visibility(
                  visible: (searchCourseMode),
                  child: Container(
                    height: 75.0,
                    margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: AppTheme.primary),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 15.0, top: 8.0, bottom: 8.0),
                        child: TextFormField(
                          controller: searchTextController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          style: CustomStyleForTextFormField.formFieldTextStyle(context),
                          decoration: CustomStyleForTextFormField.formFieldDecoration(context, Icons.search, "Search from My Courses"),
                          onChanged: (t) => setState(() => debugPrint("Search Query Changed")),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) => AppbarCard(
                  adc: null,
                  titleAppBar: "My Courses",
                  menu: GestureDetector(
                    onTap: () {
                      scrollCon.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.linear);
                      (searchCourseMode) ? searchTextController.clear() : null;
                      setState(() => searchCourseMode = !searchCourseMode);
                    },
                    child: Card(
                      elevation: 5.0,
                      child: SizedBox(
                        height: Theme.of(context).textTheme.displayMedium?.fontSize,
                        width: Theme.of(context).textTheme.displayMedium?.fontSize,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Card(
                              color: AppTheme.primary,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Center(child: Icon((!searchCourseMode) ? Icons.search : Icons.search_off, color: AppTheme.onPrimary)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  menuChildren: const SizedBox(height: 0, width: 0),
                  showBackButton: true,
                  showMoreOption: true,
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton.small(
        //   tooltip: "Search from My Course",
        //   foregroundColor: searchCourseMode ? AppTheme.primary : AppTheme.onPrimary,
        //   backgroundColor: searchCourseMode ? AppTheme.onPrimary : AppTheme.primary,
        //   onPressed: () {
        //     (searchCourseMode) ? searchTextController.clear() : null;
        //     setState(() => searchCourseMode = !searchCourseMode);
        //   },
        //   child: Icon(
        //     searchCourseMode ? Icons.search_off : Icons.search,
        //     weight: 2.0,
        //     grade: 2.0,
        //     color: searchCourseMode ? AppTheme.primary : AppTheme.onPrimary,
        //   ),
        // ),
      ),
    );
  }
}
