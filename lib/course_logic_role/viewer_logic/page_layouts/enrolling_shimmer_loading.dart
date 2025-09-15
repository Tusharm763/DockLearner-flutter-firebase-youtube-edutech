import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../../auth_logic/firebase_controls.dart';
import '../../../core/theme_set/snack_theme.dart';
import '../../../core/theme_set/theme_colors.dart';
import 'enrolled_course_details.dart';

class LoadingEnroll extends StatefulWidget {
  const LoadingEnroll({super.key, required this.cData});

  final Map<String, dynamic> cData;

  @override
  State<LoadingEnroll> createState() => _LoadingEnrollState();
}

class _LoadingEnrollState extends State<LoadingEnroll> {
  Future<bool> delayer() async {
    try {
      FirebaseControls.startCourse(context, widget.cData);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startCourseAndPushToDetails() async {
    await delayer().then(
      (value) => Timer(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).clearSnackBars();
        ShowSnackInfo.success(contentText: "Course Enrollment Successfully...").show(context);

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).push(
          PageAnimationTransition(
            pageAnimationType: RightToLeftTransition(),
            page: ViewEachForStudent(
              courseData: {
                "Title": widget.cData["Title"],
                "Description": widget.cData["Description"],
                "Author": widget.cData["Author"],
                "Id": widget.cData["Id"],
                "LT": widget.cData["LT"],
                "Length": widget.cData["Length"],
                "Progress": List.filled(widget.cData["Id"].length, "0"),
              },
            ),
          ),
        );
      }),
      onError: (e) {
        debugPrint("Failed");
        Navigator.pop(context);
      },
    );
    // } catch (e) {
    //   debugPrint("Failed");
    //   Navigator.pop(context);
    // }
  }

  @override
  void initState() {
    startCourseAndPushToDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ShowSnackInfo.error(contentText: "Please Wait...Can't Revert This...").show(context);
        return false;
      },
      child: Placeholder(
        child: Scaffold(
          backgroundColor: AppTheme.pCon,
          body: SafeArea(
            child: Stack(
              children: [
                const BackGroundWithGradientEffect(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 75.0, 10.0, 0.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: AppTheme.screenWidthInPortrait(context) * 0.65, child: const LinearProgressIndicator()),
                        const SizedBox(height: 15.0),
                        Text(
                          "Enrolling...Please Wait",
                          style: AppTheme.t4TitleLarge(context)?.copyWith(color: AppTheme.primary, letterSpacing: 1.2, fontWeight: FontWeight.bold),
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
    );
  }
}
