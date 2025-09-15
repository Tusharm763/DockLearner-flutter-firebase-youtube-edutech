import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dock_learner/course_logic_role/viewer_logic/page_layouts/enrolling_shimmer_loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../../app_info/terms_conditions_privacy.dart';
import '../../../auth_logic/firebase_controls.dart';
import '../../../core/data_model/user_data_model.dart';
import '../../../core/home_screen_widgets.dart';
import '../../../core/loading_shimmers.dart';
import '../../../core/theme_set/theme_colors.dart';
import '../../../core/thumbnail_extract_widget.dart';
import '../listview_layouts/current_courses.dart';

class NotStartedViewForEachCourseDetailsStudents extends StatefulWidget {
  final String cTitle;

  // final String cDescription;
  // final String cAuthor;
  // final List<dynamic> cId;
  // final List<dynamic> cLength;
  // final List<dynamic> cUsers;
  // final List<dynamic> cProgress;
  const NotStartedViewForEachCourseDetailsStudents({
    super.key,
    required this.cTitle,
    // required this.cDescription,
    // required this.cId,
    // required this.cAuthor,
    // required this.cLength,
    // required this.cUsers,
    // required this.cProgress,
  });

  @override
  State<NotStartedViewForEachCourseDetailsStudents> createState() => _NotStartedViewForEachCourseDetailsStudentsState();
}

class _NotStartedViewForEachCourseDetailsStudentsState extends State<NotStartedViewForEachCourseDetailsStudents> {
  bool started = false;

  bool isNameInUsers(e) {
    for (var i in e) {
      if (i.toString() == UserData.googleUserName) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  // Flutter device daemon #1 exited (exit code 255), stderr: Unhandled exception: PathAccessException: Cannot open file, path = 'C:\Users\Tushar\AppData\Roaming\.flutter_tool_state' (OS Error: The process cannot access the file because it is being used by another process. , errno = 32) #0 _File.throwIfError (dart:io/file_impl.dart:675:7) #1 _File.openSync (dart:io/file_impl.dart:490:5) #2 _File.writeAsBytesSync (dart:io/file_impl.dart:644:31) #3 _File.writeAsStringSync (dart:io/file_impl.dart:668:5) #4 ForwardingFile.writeAsStringSync (package:file/src/forwarding/forwarding_file.dart:150:16) #5 ErrorHandlingFile.writeAsStringSync.  (package:flutter_tools/src/base/error_handling_io.dart:267:22) #6 _runSync (package:flutter_tools/src/base/error_handling_io.dart:590:14) #7 ErrorHandlingFile.writeAsStringSync (package:flutter_tools/src/base/error_handling_io.dart:266:5) #8 Config._flushValues (package:flutter_tools/src/base/config.dart:185:11) #9 Config.setValue (package:flutter_tools/src/base/config.dart:174:5) #10 _DefaultPersistentToolState.setIsRunningOnBot (package:flutter_tools/src/persistent_tool_state.dart:136:13) #11 BotDetector.isRunningOnBot (package:flutter_tools/src/base/bot_detector.dart:40:28) #12 isRunningOnBot (package:flutter_tools/src/globals.dart:89:48) #13 run.  (package:flutter_tools/runner.dart:47:38) #14 runInContext.runnerWrapper (package:flutter_tools/src/context_runner.dart:83:18)   #15 AppContext.run.  (package:flutter_tools/src/base/context.dart:150:19)   #16 main (package:flutter_tools/executable.dart:90:3)

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                  child: StreamBuilder(
                    stream: FirebaseControls.readAllCourse(),
                    builder: (context, AsyncSnapshot snapshot) {
                      return snapshot.hasData
                          ? Builder(
                              builder: (context) {
                                DocumentSnapshot each = snapshot.data.docs[0];
                                for (int i = 0; i < snapshot.data.docs.length; i++) {
                                  if (snapshot.data.docs[i]["Title"] == widget.cTitle) {
                                    each = snapshot.data.docs[i];
                                  }
                                }
                                return (each["Title"] == widget.cTitle)
                                    ? SingleChildScrollView(
                                        physics: const ClampingScrollPhysics(),
                                        child: Column(
                                          children: [
                                            TitleDetails(title: each["Title"].toString()),
                                            DetailsThumbNail(textURL: each["Id"][0].toString()),
                                            const SizedBox(height: 5.0),
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
                                                                const TextSpan(text: "Course Offered By:\n"),
                                                                TextSpan(
                                                                  text: each["Author"].toString(),
                                                                  style: AppTheme.t4TitleLarge(
                                                                    context,
                                                                  )!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.primary),
                                                                ),
                                                                const TextSpan(text: "\n\nAbout this Course and Instructions:\n"),
                                                                TextSpan(
                                                                  text: each["Description"].toString(),
                                                                  style: AppTheme.t4TitleLarge(context)!.copyWith(
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: -2.0 + AppTheme.t4TitleLarge(context)!.fontSize!,
                                                                    color: AppTheme.primary,
                                                                  ),
                                                                ),
                                                                (each["Users"].length != 0)
                                                                    ? const TextSpan(text: "\n\nTotal Enrolled Students: ")
                                                                    : const TextSpan(text: "\n\nNew!!... Be the First one to Enroll..."),
                                                                (each["Users"].length != 0)
                                                                    ? TextSpan(
                                                                        text: each["Users"].length.toString(),
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
                                                      Divider(thickness: 3.0, color: AppTheme.primary),
                                                      const SizedBox(height: 7.50),
                                                      Card(
                                                        elevation: 5.0,
                                                        color: AppTheme.primary,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        backgroundColor: AppTheme.secondary,
                                                                        title: Column(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                "Enroll to ${each["Title"]}",
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
                                                                            recognizer: TapGestureRecognizer()
                                                                              ..onTap = () => Navigator.of(context).push(
                                                                                PageAnimationTransition(
                                                                                  pageAnimationType: RightToLeftTransition(),
                                                                                  page: const TCPrivacyPolicy(),
                                                                                ),
                                                                              ),
                                                                            text:
                                                                                "Are you sure with the intention to Enrolled/Join into ${each["Title"]}? And, Are You aware with the Terms and Conditions of this Course as Hereby given by the Course Instructor. And You also being Aware about the Terms and Conditions and Privacy Policy of Enrollment to A Particular Course. Learn More.",
                                                                            style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                              letterSpacing: 1,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: AppTheme.onSecondary,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              TextButton(
                                                                                onPressed: () => Navigator.pop(context),
                                                                                child: Text(
                                                                                  "Not Now",
                                                                                  style: AppTheme.t7LabelLarge(context)?.copyWith(
                                                                                    letterSpacing: 1,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: AppTheme.onSecondary,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  if (isNameInUsers(each["Users"])) {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                        builder: (BuildContext context) =>
                                                                                            const ResumeViewForEachCourseDetailsStudents(),
                                                                                      ),
                                                                                    );
                                                                                  } else {
                                                                                    Navigator.of(context).pop();
                                                                                    Navigator.of(context).push(
                                                                                      PageAnimationTransition(
                                                                                        pageAnimationType: RightToLeftTransition(),
                                                                                        page: LoadingEnroll(
                                                                                          cData: {
                                                                                            "Title": each["Title"],
                                                                                            "Description": each["Description"],
                                                                                            "Author": each["Author"],
                                                                                            "Id": each["Id"],
                                                                                            "LT": each["LT"],
                                                                                            "Length": each["Length"],
                                                                                            "Users": each["Users"],
                                                                                            "Progress": each["Progress"],
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                },
                                                                                child: Text(
                                                                                  "Enroll Now",
                                                                                  style: AppTheme.t7LabelLarge(context)?.copyWith(
                                                                                    letterSpacing: 1.5,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: AppTheme.primary,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Card(
                                                                  color: Colors.white,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(left: 7.5),
                                                                          child: Text(
                                                                            "Enroll to this Course",
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
                                                                          child: Icon(Icons.start, color: AppTheme.onPrimary),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Card(
                                              color: AppTheme.primary,
                                              child: GestureDetector(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 10.0),
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
                                                            itemCount: each["Id"].length,
                                                            itemBuilder: (BuildContext context, indexForSection) {
                                                              return Padding(
                                                                padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                                                                child: Column(
                                                                  children: [
                                                                    (indexForSection == 0)
                                                                        ? const SizedBox.shrink()
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
                                                                                  "Lecture ${indexForSection + 1} of ${each["Id"].length}",
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
                                                                        trailing: Icon(Icons.lock, color: AppTheme.primary),
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
                                            const SizedBox(height: 7.5),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink();
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
                    },
                  ),
                ),
              ),
              Builder(
                builder: (context) => const AppbarCard(
                  adc: null,
                  titleAppBar: "View Course Details",
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
