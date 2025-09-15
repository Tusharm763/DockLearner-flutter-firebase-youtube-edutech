import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dock_learner/course_logic_role/action_logic/page_layouts/view_current_enrolled.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../../app_info/terms_conditions_privacy.dart';
import '../../../auth_logic/firebase_controls.dart';
import '../../../core/data_model/user_data_model.dart';
import '../../../core/constants.dart';
import '../../../core/home_screen_widgets.dart';
import '../../../core/loading_shimmers.dart';
import '../../../core/theme_set/theme_colors.dart';
import '../../../core/thumbnail_extract_widget.dart';
import '../course_controls/create/create_course.dart';

class ViewEachForCourseOrganiser extends StatefulWidget {
  final dynamic courseData;

  const ViewEachForCourseOrganiser({super.key, required this.courseData});

  @override
  State<ViewEachForCourseOrganiser> createState() => _ViewEachForCourseOrganiserState();
}

class _ViewEachForCourseOrganiserState extends State<ViewEachForCourseOrganiser> {
  bool isRolledOut = false;

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () => loadOrRefreshFromDataBase());
    super.initState();
  }

  Stream? loadCourses;

  void loadOrRefreshFromDataBase() => setState(() => loadCourses = FirebaseFirestore.instance.collection("CourseDB").snapshots());

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
                child: StreamBuilder(
                  stream: FirebaseControls.readAllCourse(),
                  builder: (context, AsyncSnapshot snapshot) {
                    return (snapshot.hasData)
                        ? Builder(
                            builder: (context) {
                              DocumentSnapshot E;
                              int iter = 0;
                              while (iter < snapshot.data.docs.length) {
                                debugPrint(snapshot.data.docs[iter]["Title"]);
                                if (widget.courseData["Title"].toString() == snapshot.data.docs[iter]["Title"].toString()) {
                                  break;
                                }
                                iter++;
                              }
                              E = snapshot.data.docs[iter];
                              bool isAuthor = (E["Author"] == UserData.googleUserName);

                              return (isRolledOut)
                                  ? GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: const Padding(
                                        padding: EdgeInsets.fromLTRB(5.0, 125.0, 5.0, 0.0),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Column(
                                            children: [
                                              Text("The Following Course has been Deleted.", style: TextStyle(fontSize: 15.0, color: Colors.white)),
                                              SizedBox(height: 25.0),
                                              Text("Go back", style: TextStyle(fontSize: 15.0, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      physics: const ClampingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          TitleDetails(title: E["Title"].toString()),
                                          DetailsThumbNail(textURL: E["Id"][0].toString()),
                                          const SizedBox(height: 7.5),
                                          Card(
                                            child: GestureDetector(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              const TextSpan(text: "By: "),
                                                              TextSpan(
                                                                text: E["Author"].toString(),
                                                                style: AppTheme.t4TitleLarge(
                                                                  context,
                                                                )!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.primary),
                                                              ),
                                                              const TextSpan(text: "\n\nAbout this Course and Instructions:\n"),
                                                              TextSpan(
                                                                text: E["Description"].toString(),
                                                                style: AppTheme.t4TitleLarge(context)!.copyWith(
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: -2.0 + AppTheme.t4TitleLarge(context)!.fontSize!,
                                                                  color: AppTheme.primary,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: (E["Users"].length != 0)
                                                                    ? "\n\nEnrolled Students: "
                                                                    : "\n\nNew! Course!!...\nNo Students enrolled at this Time.",
                                                              ),
                                                              (E["Users"].length != 0)
                                                                  ? TextSpan(
                                                                      text: E["Users"].length.toString(),
                                                                      style: AppTheme.t4TitleLarge(
                                                                        context,
                                                                      )!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.primary),
                                                                    )
                                                                  : const TextSpan(),
                                                            ],
                                                            style: AppTheme.t5TitleMedium(
                                                              context,
                                                            )!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.primary),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 7.50),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 7.5),
                                          (isAuthor)
                                              ? Card(
                                                  color: AppTheme.primary,
                                                  child: GestureDetector(
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "More Actions",
                                                            textAlign: TextAlign.left,
                                                            style: AppTheme.t4TitleLarge(
                                                              context,
                                                            )!.copyWith(fontWeight: FontWeight.w600, letterSpacing: 1, color: AppTheme.onPrimary),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(7.5, 0.0, 7.5, 0.0),
                                                                        child: GestureDetector(
                                                                          onTap: () => Navigator.of(context).push(
                                                                            PageAnimationTransition(
                                                                              pageAnimationType: RightToLeftTransition(),
                                                                              page: EnrolledStudents(
                                                                                listStudents: widget.courseData["Users"],
                                                                                listProgress: widget.courseData["Progress"],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          child: Card(
                                                                            color: AppTheme.onPrimary,
                                                                            child: Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 7.5),
                                                                                    child: Text(
                                                                                      "View Enrolled Students",
                                                                                      style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        letterSpacing: 1.0,
                                                                                        color: AppTheme.primary,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Card(
                                                                                  color: AppTheme.primary,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: Icon(Icons.list_alt, color: AppTheme.onPrimary),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(7.5, 0.0, 7.5, 0.0),
                                                                        child: GestureDetector(
                                                                          onTap: () => showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) => AlertDialog(
                                                                              backgroundColor: AppTheme.secondary,
                                                                              title: Column(
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text(
                                                                                      'Edit This Course?',
                                                                                      style: AppTheme.t6TitleSmall(context)?.copyWith(
                                                                                        letterSpacing: 1,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: AppTheme.onPrimary,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Divider(thickness: 2.75, color: AppTheme.onSecondary),
                                                                                ],
                                                                              ),
                                                                              content: RichText(
                                                                                textAlign: TextAlign.justify,
                                                                                text: TextSpan(
                                                                                  text:
                                                                                      "In Order to Edit a Course, One has to 'Add New Course' with same 'Course Title' of this Course.\n'Learn More'.",
                                                                                  // 'Try again after some time. Try checking the Wifi Connection or Mobile Data and then try again',
                                                                                  recognizer: TapGestureRecognizer()
                                                                                    ..onTap = () => Navigator.of(context).push(
                                                                                      PageAnimationTransition(
                                                                                        pageAnimationType: RightToLeftTransition(),
                                                                                        page: const TCPrivacyPolicy(),
                                                                                      ),
                                                                                    ),
                                                                                  style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                                    letterSpacing: 1,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: AppTheme.onPrimary,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              actions: [
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pop(context);
                                                                                    Navigator.of(context).push(
                                                                                      PageAnimationTransition(
                                                                                        pageAnimationType: RightToLeftTransition(),
                                                                                        page: const AddCourseToCloudDatabase(),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  child: Text(
                                                                                    "Re-Create",
                                                                                    style: AppTheme.t6TitleSmall(context)?.copyWith(
                                                                                      letterSpacing: 1,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: AppTheme.primary,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          child: Card(
                                                                            color: AppTheme.onPrimary,
                                                                            child: Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 7.5),
                                                                                    child: Text(
                                                                                      "Edit Course Instructions",
                                                                                      style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        letterSpacing: 1.0,
                                                                                        color: AppTheme.primary,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                    // ),
                                                                                  ),
                                                                                ),
                                                                                Card(
                                                                                  color: AppTheme.primary,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: Icon(Icons.edit, color: AppTheme.onPrimary),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(7.5, 0.0, 7.5, 0.0),
                                                                        child: GestureDetector(
                                                                          onTap: () => showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) => AlertDialog(
                                                                              backgroundColor: AppTheme.secondary,
                                                                              title: Column(
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text(
                                                                                      'Confirm Delete Course?',
                                                                                      style: AppTheme.t6TitleSmall(context)?.copyWith(
                                                                                        letterSpacing: 1,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: AppTheme.onPrimary,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Divider(thickness: 2.75, color: AppTheme.onSecondary),
                                                                                ],
                                                                              ),
                                                                              content: RichText(
                                                                                textAlign: TextAlign.justify,
                                                                                text: TextSpan(
                                                                                  text:
                                                                                      "Are you sure, You want to delete this Course? Note: The course will be active for all the Students who are currently Enrolled. 'Learn More'.",
                                                                                  recognizer: TapGestureRecognizer()
                                                                                    ..onTap = () => Navigator.of(context).push(
                                                                                      PageAnimationTransition(
                                                                                        pageAnimationType: RightToLeftTransition(),
                                                                                        page: const TCPrivacyPolicy(),
                                                                                      ),
                                                                                    ),
                                                                                  style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                                    letterSpacing: 1,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: AppTheme.onPrimary,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              actions: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    TextButton(
                                                                                      onPressed: () => Navigator.pop(context),
                                                                                      clipBehavior: Clip.antiAlias,
                                                                                      child: Text(
                                                                                        "Not Now",
                                                                                        style: AppTheme.t7LabelLarge(context)?.copyWith(
                                                                                          fontFamily: 'SourGummy',
                                                                                          letterSpacing: 1,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: AppTheme.onSecondary,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        setState(() => isRolledOut = true);
                                                                                        FirebaseControls.deleteCourseFromFirebaseCourseDB(
                                                                                          widget.courseData["Title"],
                                                                                        ).then((value) {
                                                                                          debugPrint("Deleted");
                                                                                          Navigator.pop(context);
                                                                                          Navigator.pop(context);
                                                                                        });
                                                                                      },
                                                                                      clipBehavior: Clip.antiAlias,
                                                                                      child: Text(
                                                                                        "Yes, Delete",
                                                                                        style: AppTheme.t7LabelLarge(context)?.copyWith(
                                                                                          fontFamily: 'SourGummy',
                                                                                          letterSpacing: 1,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: AppTheme.error,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          child: Card(
                                                                            color: AppTheme.onPrimary,
                                                                            child: Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 7.5),
                                                                                    child: Text(
                                                                                      "Delete This Course",
                                                                                      style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        letterSpacing: 1.0,
                                                                                        color: AppTheme.error,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Card(
                                                                                  color: AppTheme.error,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: Icon(
                                                                                      Icons.folder_delete_outlined,
                                                                                      color: AppTheme.onError,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(width: 0.0, height: 0.0),
                                          SizedBox(height: (isAuthor) ? 7.5 : 0.0),
                                          Card(
                                            color: AppTheme.primary,
                                            child: GestureDetector(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Course Lectures",
                                                      textAlign: TextAlign.left,
                                                      style: AppTheme.t4TitleLarge(
                                                        context,
                                                      )!.copyWith(fontWeight: FontWeight.w600, letterSpacing: 1, color: AppTheme.onPrimary),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Card(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: const ClampingScrollPhysics(),
                                                          itemCount: E["Id"].length,
                                                          itemBuilder: (BuildContext context, iterationForSection) {
                                                            return Padding(
                                                              padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                                                              child: Column(
                                                                children: [
                                                                  (iterationForSection == 0)
                                                                      ? const SizedBox(height: 0.0, width: 00.0)
                                                                      : Divider(thickness: 2.0, color: AppTheme.secondary),
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(7.5, 0.0, 7.5, 0.0),
                                                                    child: ListTile(
                                                                      title: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child: SingleChildScrollView(
                                                                              scrollDirection: Axis.horizontal,
                                                                              child: Text(
                                                                                E["LT"][iterationForSection].toString(),
                                                                                textAlign: TextAlign.left,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: AppTheme.t4TitleLarge(
                                                                                  context,
                                                                                )!.copyWith(fontWeight: FontWeight.w600, color: AppTheme.primary),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      trailing: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            size: AppTheme.t5TitleMedium(context)!.fontSize! + 1,
                                                                            color: AppTheme.primary,
                                                                          ),
                                                                          const SizedBox(width: 2.5),
                                                                          Text(
                                                                            secToHHMMSS(int.parse(E["Length"][iterationForSection])).toString(),
                                                                            textAlign: TextAlign.left,
                                                                            style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              letterSpacing: 1.5,
                                                                              color: AppTheme.primary,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          )
                        : ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                child: Align(alignment: Alignment.centerLeft, child: DisplayLoadingDetailsHeadingTitle()),
                              ),
                              DisplayLoadingHomeScreenCard(),
                              DisplayLoadingHomeScreenCard(),
                              DisplayLoadingHomeScreenCard(),
                              DisplayLoadingHomeScreenCard(),
                            ],
                          );

                    // : const CircularProgressIndicator();
                  },
                ),
              ),
              Builder(
                builder: (context) {
                  return const AppbarCard(
                    adc: null,
                    titleAppBar: "View Course Details",
                    //widget.courseData["Title"].toString(),
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
