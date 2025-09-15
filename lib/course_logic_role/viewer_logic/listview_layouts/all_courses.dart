import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../../auth_logic/firebase_controls.dart';
import '../../../core/data_model/user_data_model.dart';
import '../../../core/constants.dart';
import '../../../core/loading_shimmers.dart';
import '../../../core/theme_set/snack_theme.dart';
import '../../../core/theme_set/theme_colors.dart';
import '../page_layouts/completed_course_detail.dart';
import '../page_layouts/course_details.dart';
import '../page_layouts/enrolled_course_details.dart';

class ViewCoursesFromFirebaseDB extends StatefulWidget {
  const ViewCoursesFromFirebaseDB({super.key});

  @override
  State<ViewCoursesFromFirebaseDB> createState() => _ViewCoursesFromFirebaseDBState();
}

class _ViewCoursesFromFirebaseDBState extends State<ViewCoursesFromFirebaseDB> {
  bool filterOutMyCourses = false;
  bool searchCourseMode = false;
  TextEditingController searchTextController = TextEditingController();
  ScrollController scrollCon = ScrollController();

  bool isStudentInUsers(e) {
    for (var i in e) {
      if ("$i" == UserData.googleUserName) return true;
    }
    return false;
  }

  bool isCompleted(List<dynamic> e, List<dynamic> c) {
    int ind = -1;
    ind = e.indexOf(UserData.googleUserName.toString());
    return (c[ind].toString().trim() == "COMPLETED") ? true : false;
  }

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

  void filterOutMyCourse() {
    setState(() => filterOutMyCourses = !filterOutMyCourses);
    scrollCon.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) => Placeholder(
    child: Scaffold(
      backgroundColor: AppTheme.pCon,
      body: SafeArea(
        child: Stack(
          children: [
            const BackGroundWithGradientEffect(),
            Padding(
              padding: EdgeInsets.only(top: searchCourseMode ? 75.0 + 75.0 + 10.0 : 75.0),
              child: Scrollbar(
                controller: scrollCon,
                child: StreamBuilder(
                  stream: FirebaseControls.readAllCourse(),
                  builder: (context, AsyncSnapshot snapshot) {
                    late List<DocumentSnapshot> shuffledSnapshot;
                    if (snapshot.hasData) {
                      shuffledSnapshot = snapshot.data.docs.toList();
                      // shuffledSnapshot.shuffle();
                    }
                    return snapshot.hasData
                        ? (shuffledSnapshot.isNotEmpty)
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 2.50),
                                  // child: ScrollToTop(
                                  //   scrollController: scrollCon,
                                  //   btnColor: AppTheme.secondary,
                                  //   txtColor: AppTheme.onSecondary,
                                  //   scrollOffset: int.parse(
                                  //     (AppTheme.screenHeightInPortrait(context).toInt() * .30)
                                  //         .round()
                                  //         .toInt()
                                  //         .toString(),
                                  //   ),
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    trackVisibility: true,
                                    thickness: 5.75,
                                    interactive: true,
                                    radius: const Radius.circular(5.75),
                                    controller: scrollCon,
                                    child: ListView.builder(
                                      controller: scrollCon,
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 7.50),
                                      itemCount: shuffledSnapshot.length + 1 + 1,
                                      //data.docs.length + 1,
                                      itemBuilder: (context, iterateWithTwo) {
                                        int coursesInListView = 0;
                                        for (var iii in shuffledSnapshot) {
                                          if (isStudentInUsers(iii["Users"])) {
                                            coursesInListView++;
                                          }
                                        }
                                        if (iterateWithTwo == shuffledSnapshot.length + 1) {
                                          return Builder(
                                            builder: (context) {
                                              int searchResultCount = 0;
                                              if (searchCourseMode) {
                                                if (searchTextController.text.isNotEmpty) {
                                                  for (DocumentSnapshot i in shuffledSnapshot) {
                                                    if (i["Title"].toString().trim().toUpperCase().contains(
                                                      searchTextController.text.toString().toUpperCase(),
                                                    )) {
                                                      searchResultCount++;
                                                      if (filterOutMyCourses) {
                                                        if (isStudentInUsers(i["Users"])) {
                                                          searchResultCount--;
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                              return SizedBox(
                                                width: AppTheme.screenWidthInPortrait(context),
                                                height: (filterOutMyCourses)
                                                    ? 1.7 * MediaQuery.of(context).size.width * 0.25
                                                    : MediaQuery.of(context).size.width * 0.25,
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
                                                            ? "That's All for Now..\nSearch Result: $searchResultCount / ${(filterOutMyCourses) ? shuffledSnapshot.length - coursesInListView : shuffledSnapshot.length} Courses...\n"
                                                            : "That's All for Now..\nTotal: ${(filterOutMyCourses) ? shuffledSnapshot.length - coursesInListView : shuffledSnapshot.length} Courses...\n",
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
                                                      (filterOutMyCourses) ? "Search from Filtered Courses" : "Search from All Courses",
                                                    ),
                                                    onChanged: (t) => setState(() => debugPrint("Search Query Changed")),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          int iterate = iterateWithTwo - 1;
                                          DocumentSnapshot each = shuffledSnapshot[iterate];
                                          if (filterOutMyCourses) {
                                            if (isStudentInUsers(each["Users"])) {
                                              return const SizedBox(width: 0.0, height: 0.0);
                                            }
                                          }
                                          if (searchCourseMode) {
                                            if (searchTextController.text.isNotEmpty) {
                                              if (false ==
                                                  (each["Title"].toString().trim().toUpperCase().contains(
                                                    searchTextController.text.toString().toUpperCase(),
                                                  ))) {
                                                return const SizedBox.shrink();
                                              }
                                            }
                                          }
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
                                                                  onTap: () => Navigator.of(context).push(
                                                                    PageAnimationTransition(
                                                                      pageAnimationType: RightToLeftTransition(),
                                                                      page: (isStudentInUsers(each["Users"]))
                                                                          ? (FirebaseControls.isCourseCompleted(each["Users"], each["Progress"]))
                                                                                ? ViewEachForStudent(courseData: each)
                                                                                : ViewDetailsCompletedCourses(cTitle: each["Title"])
                                                                          : NotStartedViewForEachCourseDetailsStudents(
                                                                              cTitle: each["Title"],
                                                                              // cDescription: each["Description"],
                                                                              // cAuthor: each["Author"],
                                                                              // cId: each["Id"],
                                                                              // cLength: each["Length"],
                                                                              // cUsers: each["Users"],
                                                                              // cProgress: each["Progress"],
                                                                            ),
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
                                                                                (isStudentInUsers(each["Users"]))
                                                                                    ? (isCompleted(each["Users"], each["Progress"]))
                                                                                          ? "100 %"
                                                                                          : "Resume"
                                                                                    : "View",
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
                                  // ),
                                )
                              : ListView(
                                  controller: scrollCon,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  children: [
                                    const SizedBox(height: 50.0),
                                    Text(
                                      "No Courses at this Time...\nPlease try Again after some Time\n",
                                      style: AppTheme.t6TitleSmall(
                                        context,
                                      )!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.50, color: AppTheme.primary),
                                    ),
                                    Divider(indent: 15.0, endIndent: 15.0, color: AppTheme.primary, thickness: 2.0),
                                  ],
                                )
                        : ListView(
                            controller: scrollCon,
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
            ),
            Visibility(
              visible: (filterOutMyCourses),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: AppTheme.primary,
                  width: AppTheme.screenWidthInPortrait(context),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Filter:\n",
                            style: AppTheme.t8LabelMedium(context)!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onPrimary),
                          ),
                          const TextSpan(text: "'Courses excluding the Enrolled one.'\nShow Course which you have not been Enrolled Till Now."),
                        ],
                        style: AppTheme.t9LabelSmall(context)!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onPrimary),
                      ),
                    ),
                  ),
                ),
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
                        decoration: CustomStyleForTextFormField.formFieldDecoration(
                          context,
                          Icons.search,
                          (filterOutMyCourses) ? "Search from Filtered Courses" : "Search from All Courses",
                        ),
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
                titleAppBar: (filterOutMyCourses) ? "Filtered Courses" : "All Available Courses",
                menu: true
                    ? GestureDetector(
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
                                  child: Center(
                                    child: Icon((!searchCourseMode) ? Icons.search : Icons.search_off, color: AppTheme.onPrimary, size: 30),
                                  ),
                                ),
                                (searchCourseMode)
                                    ? Align(
                                        alignment: Alignment.bottomRight,
                                        child: SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 1.0, bottom: 1.0),
                                            child: Card(
                                              color: Colors.green.shade600.withValues(alpha: 0.7),
                                              child: Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: Icon(Icons.circle, color: Colors.green.shade800, size: 11.500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(width: 0.0, height: 0.0),
                              ],
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: filterOutMyCourse,
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
                                  child: Center(
                                    child: Icon((!filterOutMyCourses) ? Icons.filter_alt : Icons.filter_alt_off, color: AppTheme.onPrimary, size: 30),
                                  ),
                                ),
                                (filterOutMyCourses)
                                    ? Align(
                                        alignment: Alignment.bottomRight,
                                        child: SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 1.0, bottom: 1.0),
                                            child: Card(
                                              color: Colors.green.shade600.withValues(alpha: 0.7),
                                              child: Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: Icon(Icons.circle, color: Colors.green.shade800, size: 11.500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(width: 0.0, height: 0.0),
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
      //TODO: ___
      floatingActionButton: true
          ? FloatingActionButton.extended(
              tooltip: searchCourseMode ? "Search from 'Filtered Courses'" : "Search from All Course",
              foregroundColor: searchCourseMode
                  ? filterOutMyCourses
                        ? AppTheme.secondary
                        : AppTheme.primary
                  : filterOutMyCourses
                  ? AppTheme.onSecondary
                  : AppTheme.onPrimary,
              backgroundColor: searchCourseMode
                  ? filterOutMyCourses
                        ? AppTheme.onSecondary
                        : AppTheme.onPrimary
                  : filterOutMyCourses
                  ? AppTheme.secondary
                  : AppTheme.primary,
              onPressed: filterOutMyCourse,
              label: Icon(
                !filterOutMyCourses ? Icons.filter_alt : Icons.filter_alt_off,
                // weight: 2.0,
                // grade: 2.0,
                size: 32.50,
                color: searchCourseMode
                    ? filterOutMyCourses
                          ? AppTheme.secondary
                          : AppTheme.primary
                    : filterOutMyCourses
                    ? AppTheme.onSecondary
                    : AppTheme.onPrimary,
              ),
            )
          : FloatingActionButton.extended(
              tooltip: filterOutMyCourses ? "Search from 'Filtered Courses'" : "Search from All Course",
              foregroundColor: searchCourseMode
                  ? filterOutMyCourses
                        ? AppTheme.secondary
                        : AppTheme.primary
                  : filterOutMyCourses
                  ? AppTheme.onSecondary
                  : AppTheme.onPrimary,
              backgroundColor: searchCourseMode
                  ? filterOutMyCourses
                        ? AppTheme.onSecondary
                        : AppTheme.onPrimary
                  : filterOutMyCourses
                  ? AppTheme.secondary
                  : AppTheme.primary,
              onPressed: () {
                scrollCon.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.linear);
                (searchCourseMode) ? searchTextController.clear() : null;
                setState(() => searchCourseMode = !searchCourseMode);
              },
              label: Icon(
                searchCourseMode ? Icons.search_off : Icons.search,
                // weight: 2.0,
                // grade: 2.0,
                size: 32.50,
                color: searchCourseMode
                    ? filterOutMyCourses
                          ? AppTheme.secondary
                          : AppTheme.primary
                    : filterOutMyCourses
                    ? AppTheme.onSecondary
                    : AppTheme.onPrimary,
              ),
            ),
    ),
  );
}
