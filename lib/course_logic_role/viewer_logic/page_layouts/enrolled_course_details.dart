import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../../app_info/terms_conditions_privacy.dart';
import '../../../auth_logic/firebase_controls.dart';
import '../../../core/data_model/user_data_model.dart';
import '../../../core/constants.dart';
import '../../../core/home_screen_widgets.dart';
import '../../../core/loading_shimmers.dart';
import '../../../core/theme_set/snack_theme.dart';
import '../../../core/theme_set/theme_colors.dart';
import '../../../core/thumbnail_extract_widget.dart';
import '../media_player_lectures/completed_player_youtube.dart';
import '../media_player_lectures/media_player_youtube.dart';
import 'completed_course_detail.dart';

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

class ViewEachForStudent extends StatefulWidget {
  final dynamic courseData;

  const ViewEachForStudent({super.key, required this.courseData});

  @override
  State<ViewEachForStudent> createState() => _ViewEachForStudentState();
}

class _ViewEachForStudentState extends State<ViewEachForStudent> {
  bool isDeleted = false;
  late final Box box;
  bool valueAutoPlay = false;
  int valueAutoSave = 5;

  void changeAutoSaveValueInFirebase(var E, int newVal) {
    FirebaseFirestore.instance
        .collection("StudentDB")
        .doc(UserData.googleUserEmail)
        .collection("Current Joined")
        .doc(E["Title"])
        .update({"AutoSave": newVal.toString()})
        .then((value) => ShowSnackInfo.success(contentText: "AutoSave change to $newVal %.").show(context))
        .then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    box = Hive.box('ALL');
    super.initState();
  }

  Future<void> routeToYoutubePlayer(DocumentSnapshot E, int currentIndex) async {
    valueAutoPlay = box.get('AutoPlay', defaultValue: false);
    valueAutoSave = box.get('AutoSave', defaultValue: 5);
    valueAutoPlay = E["AutoPlay"] == "Y";
    valueAutoSave = int.parse(E["AutoSave"].toString());

    bool isZero = (int.parse(E["Progress"][currentIndex]) == 0);
    bool isHundred = (int.parse(E["Progress"][currentIndex]) == 100);
    int startSeconds = 0;
    int currentPercentage = int.parse(E["Progress"][currentIndex]);
    if (isHundred) {
      setState(() => startSeconds = 0);
      setState(() => currentPercentage = 100);
      Navigator.of(context).push(
        PageAnimationTransition(
          pageAnimationType: RightToLeftTransition(),
          page: YoutubePlayerCompletedPage(
            // autoSaving: valueAutoSave,
            // previousPercentage: currentPercentage,
            courseTitle: E["Title"],
            lectureIndexInId: currentIndex,
            noOfLecture: E["Id"].length,
            // startFrom: startSeconds,
            idYoutube: E["Id"][currentIndex],
            // autoPlayVideo: valueAutoPlay,
          ),
        ),
      );
    } else if (isZero) {
      Navigator.of(context).push(
        PageAnimationTransition(
          pageAnimationType: RightToLeftTransition(),
          page: YoutubePlayerPage(
            autoSaving: valueAutoSave,
            previousPercentage: currentPercentage,
            courseTitle: E["Title"],
            lectureIndexInId: currentIndex,
            noOfLecture: E["Id"].length,
            startFrom: startSeconds,
            idYoutube: E["Id"][currentIndex],
            autoPlayVideo: valueAutoPlay,
          ),
        ),
      );
    } else {
      int percentagePrevious = int.parse(E['Progress'][currentIndex].toString());
      int le = int.parse(E['Length'][currentIndex].toString());
      int starter = percentagePrevious * le;
      starter = (starter / 100).round();
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
                    "Resume?",
                    style: AppTheme.t6TitleSmall(context)?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w600, color: AppTheme.onPrimary),
                  ),
                ),
                Divider(thickness: 2.75, color: AppTheme.onSecondary),
              ],
            ),
            content: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      Navigator.of(context).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const TCPrivacyPolicy())),
                text:
                    "You have already completed ${E['Progress'][currentIndex]}% of this Part. Do you want to resume from ${secToHHMMSS(starter)} or Start from 00:00.",
                style: AppTheme.t8LabelMedium(context)?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w600, color: AppTheme.onSecondary),
              ),
            ),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      valueAutoPlay = box.get('AutoPlay', defaultValue: false);
                      valueAutoSave = box.get('AutoSave', defaultValue: false);
                      valueAutoPlay = E["AutoPlay"] == "Y";
                      valueAutoSave = int.parse(E["AutoSave"].toString());
                      setState(() {
                        int lengthSet = int.parse(E['Length'][currentIndex]);
                        startSeconds = (currentPercentage * lengthSet / 100).round();
                      });
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        PageAnimationTransition(
                          pageAnimationType: RightToLeftTransition(),
                          page: YoutubePlayerPage(
                            autoSaving: valueAutoSave,
                            previousPercentage: currentPercentage,
                            courseTitle: E["Title"],
                            lectureIndexInId: currentIndex,
                            noOfLecture: E["Id"].length,
                            startFrom: startSeconds,
                            idYoutube: E["Id"][currentIndex],
                            autoPlayVideo: valueAutoPlay,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Yes, Resume",
                      style: AppTheme.t7LabelLarge(context)?.copyWith(
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSecondary,
                        // color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      valueAutoPlay = box.get('AutoPlay', defaultValue: false);
                      valueAutoSave = box.get('AutoSave', defaultValue: false);
                      valueAutoPlay = E["AutoPlay"] == "Y";
                      valueAutoSave = int.parse(E["AutoSave"].toString());
                      setState(() => startSeconds = 0);
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        PageAnimationTransition(
                          pageAnimationType: RightToLeftTransition(),
                          page: YoutubePlayerPage(
                            autoSaving: valueAutoSave,
                            previousPercentage: currentPercentage,
                            courseTitle: E["Title"],
                            lectureIndexInId: currentIndex,
                            noOfLecture: E["Id"].length,
                            startFrom: startSeconds,
                            idYoutube: E["Id"][currentIndex],
                            autoPlayVideo: valueAutoPlay,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "No, Start Over",
                      style: AppTheme.t7LabelLarge(context)?.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w600, color: AppTheme.error),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
    debugPrint(startSeconds.toString());
    debugPrint(currentPercentage.toString());
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
                padding: const EdgeInsets.fromLTRB(10.0, 75.0, 10.0, 0.0),
                child: (isDeleted)
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
                    : StreamBuilder(
                        stream: FirebaseControls.readCurrentCourse(),
                        builder: (context, AsyncSnapshot snapshot) {
                          return (snapshot.hasData)
                              ? Builder(
                                  builder: (context) {
                                    DocumentSnapshot E;
                                    int iter = 0;
                                    int whichIndex = 0;
                                    while (iter < snapshot.data.docs.length) {
                                      debugPrint(snapshot.data.docs[iter]["Title"]);
                                      if ("${widget.courseData["Title"]}" == "${snapshot.data.docs[iter]["Title"]}") {
                                        break;
                                      }
                                      iter++;
                                    }
                                    bool isRolledOut = false;
                                    try {
                                      E = snapshot.data.docs[iter];
                                      //TOD O : check for COMPLETED
                                    } catch (e) {
                                      E = snapshot.data.docs[iter - 1];
                                      isRolledOut = true;
                                    }
                                    bool isCourseCompleted = false;
                                    if (!(isRolledOut)) {
                                      for (var i in E["Progress"]) {
                                        if ("$i" == "100") {
                                          whichIndex++;
                                        }
                                      }
                                      if (whichIndex >= E["Id"].length) {
                                        isCourseCompleted = true;
                                        whichIndex = 0;
                                      }
                                    }
                                    return (isRolledOut)
                                        ? GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(5.0, 125.0, 5.0, 0.0),
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Column(
                                                  children: [
                                                    Text("Something Went Wrong", style: TextStyle(fontSize: 15.0, color: Colors.white)),
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
                                                                    const TextSpan(text: "Course Offered By:\n"),
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
                                                                  (int.parse(getTotalProgressAverage(E["Progress"], E["Length"])) >= 1 &&
                                                                          getTotalProgressAverage(E["Progress"], E["Length"]) != "100")
                                                                      ? Card(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: MediaQuery.sizeOf(context).width * 0.5,
                                                                                  child: LinearProgressIndicator(
                                                                                    value:
                                                                                        (double.parse(
                                                                                          getTotalProgressAverage(E["Progress"], E["Length"]),
                                                                                        ) /
                                                                                        100),
                                                                                    semanticsLabel:
                                                                                        (double.parse(
                                                                                                  getTotalProgressAverage(E["Progress"], E["Length"]),
                                                                                                ) /
                                                                                                100)
                                                                                            .toString(),
                                                                                    backgroundColor: AppTheme.primary,
                                                                                    valueColor: AlwaysStoppedAnimation(AppTheme.tertiary),
                                                                                    color: AppTheme.primary,
                                                                                    minHeight: 7.50,
                                                                                  ),
                                                                                ),
                                                                                Flexible(
                                                                                  child: RichText(
                                                                                    text: TextSpan(
                                                                                      children: [
                                                                                        TextSpan(
                                                                                          text:
                                                                                              "${getTotalProgressAverage(E["Progress"], E["Length"])}%",
                                                                                          style: AppTheme.t4TitleLarge(context)!.copyWith(
                                                                                            fontWeight: FontWeight.w600,
                                                                                            color: Colors.green.shade800,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : const SizedBox(height: 0.0, width: 0.0),
                                                                  const SizedBox(height: 5.0),
                                                                  //TODO: RESUME COURSE
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      valueAutoPlay = box.get('AutoPlay', defaultValue: false);
                                                                      valueAutoSave = box.get('AutoSave', defaultValue: 5);
                                                                      valueAutoPlay = E["AutoPlay"] == "Y";
                                                                      valueAutoSave = int.parse(E["AutoSave"].toString());
                                                                      setState(() {
                                                                        if (isCourseCompleted) Navigator.pop(context);
                                                                        Navigator.of(context).push(
                                                                          PageAnimationTransition(
                                                                            pageAnimationType: RightToLeftTransition(),
                                                                            page: (isCourseCompleted)
                                                                                ? ViewDetailsCompletedCourses(cTitle: E["Title"])
                                                                                : YoutubePlayerPage(
                                                                                    autoSaving: valueAutoSave,
                                                                                    previousPercentage: (isCourseCompleted)
                                                                                        ? 0
                                                                                        : int.parse(E["Progress"][whichIndex]),
                                                                                    courseTitle: E["Title"],
                                                                                    lectureIndexInId: whichIndex,
                                                                                    noOfLecture: E["Id"].length,
                                                                                    startFrom: (isCourseCompleted)
                                                                                        ? 0
                                                                                        : int.parse(
                                                                                            (int.parse(E["Progress"][whichIndex]) *
                                                                                                    int.parse(E["Length"][whichIndex]) /
                                                                                                    100)
                                                                                                .round()
                                                                                                .toString(),
                                                                                          ),
                                                                                    idYoutube: E["Id"][whichIndex],
                                                                                    autoPlayVideo: valueAutoPlay,
                                                                                  ),
                                                                          ),
                                                                        );
                                                                      });
                                                                    },
                                                                    child: Card(
                                                                      color: Colors.white,
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(left: 7.5),
                                                                              child: Text(
                                                                                (isCourseCompleted) ? "View in Certifications" : "Resume this Course",
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
                                                                              child: Icon(
                                                                                (isCourseCompleted) ? Icons.card_giftcard : Icons.start,
                                                                                color: AppTheme.onPrimary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 5.0),
                                                                  // TODO: AutoPlay
                                                                  GestureDetector(
                                                                    onTap: () async => showDialog(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        bool isAutoPlayON = (E["AutoPlay"] == "Y");
                                                                        return AlertDialog(
                                                                          backgroundColor: AppTheme.secondary,
                                                                          title: Column(
                                                                            children: [
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  isAutoPlayON ? "Turn-Off AutoPlay Video?" : "AutoPlay Video?",
                                                                                  style: AppTheme.t6TitleSmall(context)?.copyWith(
                                                                                    letterSpacing: 1,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: AppTheme.onPrimary,
                                                                                    // color: Colors.deepPurple,
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
                                                                                ..onTap = () {
                                                                                  Navigator.of(context).push(
                                                                                    PageAnimationTransition(
                                                                                      pageAnimationType: RightToLeftTransition(),
                                                                                      page: const TCPrivacyPolicy(),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              text: isAutoPlayON
                                                                                  ? "AutoPlay Feature helps you to Auto Start the Youtube Video as soon as you Go to Section Screen. Do you want to Turn it ${isAutoPlayON ? "ON" : "OFF"}?"
                                                                                  : "AutoPlay Feature helps you to Auto Start the Youtube Video as soon as you Go to Section Screen. Do you want to Turn it ON?",
                                                                              style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                                letterSpacing: 1,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: AppTheme.onSecondary,
                                                                                // color: Colors.deepPurple,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                ElevatedButton(
                                                                                  onPressed: () async {
                                                                                    //TODO: Firebase AutoPlay Config.
                                                                                    FirebaseFirestore.instance
                                                                                        .collection("StudentDB")
                                                                                        .doc(UserData.googleUserEmail)
                                                                                        .collection("Current Joined")
                                                                                        .doc(E["Title"])
                                                                                        .update({"AutoPlay": isAutoPlayON ? "N" : "Y"})
                                                                                        .then(
                                                                                          (value) =>
                                                                                              setState(() => isAutoPlayON = E["AutoPlay"] == "Y"),
                                                                                        )
                                                                                        .then(
                                                                                          (value) => ShowSnackInfo.success(
                                                                                            contentText:
                                                                                                "AutoPlay Turned ${(isAutoPlayON) ? "OFF" : "ON"} Successfully.",
                                                                                          ).show(context),
                                                                                        )
                                                                                        .then((value) => Navigator.pop(context));
                                                                                  },
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  child: Text(
                                                                                    isAutoPlayON ? "Turn Off" : "Yes, Turn On",
                                                                                    // Sign-In "",
                                                                                    style: AppTheme.t7LabelLarge(context)?.copyWith(
                                                                                      letterSpacing: 1,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: AppTheme.error,
                                                                                      // color: Colors.deepPurple,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                    child: Card(
                                                                      color: Colors.white,
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(left: 7.5),
                                                                              child: Text(
                                                                                (E["AutoPlay"].toString() != "Y")
                                                                                    ? "AutoPlay : OFF"
                                                                                    : "AutoPlay : ON",
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
                                                                              child: Icon(Icons.replay, color: AppTheme.onPrimary),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 5.0),
                                                                  // TODO: AutoSave
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (context) {
                                                                          //TODO:AutoPlay is ON
                                                                          int autoSavingValue = int.parse(E["AutoSave"]);
                                                                          return AlertDialog(
                                                                            backgroundColor: AppTheme.secondary,
                                                                            title: Column(
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    "AutoSaving Percentage...",
                                                                                    style: AppTheme.t6TitleSmall(context)?.copyWith(
                                                                                      letterSpacing: 1,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: AppTheme.onPrimary,
                                                                                      // color: Colors.deepPurple,
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
                                                                                  ..onTap = () {
                                                                                    Navigator.of(context).push(
                                                                                      PageAnimationTransition(
                                                                                        pageAnimationType: RightToLeftTransition(),
                                                                                        page: const TCPrivacyPolicy(),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                text:
                                                                                    "AutoSaving Feature is Saving the Progress after every 'N' Percentage of that Video Lecture. \nLearn More in Terms and Conditions.\n\nDo you want to Change?",
                                                                                style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                                  letterSpacing: 1,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: AppTheme.onSecondary,
                                                                                  // color: Colors.deepPurple,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(context),
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    child: Text(
                                                                                      "No, Keep $autoSavingValue %.",
                                                                                      // Sign-In "",
                                                                                      style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                                        letterSpacing: 1,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: AppTheme.onSecondary,
                                                                                        // color: Colors.deepPurple,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      (autoSavingValue != 3)
                                                                                          ? ElevatedButton(
                                                                                              onPressed: () async {
                                                                                                changeAutoSaveValueInFirebase(E, 3);
                                                                                                // await box
                                                                                                //     .put('AutoSave', 3)
                                                                                                //     .then((value) => ShowSnackInfo.success(
                                                                                                //   contentText:
                                                                                                //   "AutoSave Changed: ${box.get('AutoSave')} %",
                                                                                                // ).show(context))
                                                                                                //     .then((value) => Navigator.pop(context));
                                                                                                debugPrint(
                                                                                                  box.get('AutoSave', defaultValue: 3).toString(),
                                                                                                );
                                                                                              },
                                                                                              clipBehavior: Clip.antiAlias,
                                                                                              child: Text(
                                                                                                "3 %",
                                                                                                // Sign-In "",
                                                                                                style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                                                  letterSpacing: 1,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: AppTheme.secondary,
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          : const SizedBox.shrink(),
                                                                                      (autoSavingValue != 5)
                                                                                          ? ElevatedButton(
                                                                                              onPressed: () async {
                                                                                                changeAutoSaveValueInFirebase(E, 5);
                                                                                                // await box
                                                                                                //     .put('AutoSave', 5)
                                                                                                //     .then((value) => ShowSnackInfo.success(
                                                                                                //   contentText:
                                                                                                //   "AutoSave Changed: ${box.get('AutoSave')} %",
                                                                                                // ).show(context))
                                                                                                //     .then((value) => Navigator.pop(context));
                                                                                                debugPrint(
                                                                                                  box.get('AutoSave', defaultValue: 5).toString(),
                                                                                                );
                                                                                                // Navigator.pop(context);
                                                                                              },
                                                                                              clipBehavior: Clip.antiAlias,
                                                                                              child: Text(
                                                                                                "5 %",
                                                                                                // Sign-In "",
                                                                                                style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                                                  letterSpacing: 1,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: AppTheme.secondary,
                                                                                                  // color: Colors.deepPurple,
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          : const SizedBox.shrink(),
                                                                                      (autoSavingValue != 10)
                                                                                          ? ElevatedButton(
                                                                                              onPressed: () async {
                                                                                                changeAutoSaveValueInFirebase(E, 10);
                                                                                                // await box
                                                                                                //     .put('AutoSave', 10)
                                                                                                //     .then((value) => ShowSnackInfo.success(
                                                                                                //   contentText:
                                                                                                //   "AutoSave Changed: ${box.get('AutoSave')} %",
                                                                                                // ).show(context))
                                                                                                //     .then((value) => Navigator.pop(context));
                                                                                                debugPrint(
                                                                                                  box.get('AutoSave', defaultValue: 10).toString(),
                                                                                                );
                                                                                                // Navigator.pop(context);
                                                                                              },
                                                                                              clipBehavior: Clip.antiAlias,
                                                                                              child: Text(
                                                                                                "10 %",
                                                                                                // Sign-In "",
                                                                                                style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                                                  letterSpacing: 1,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: AppTheme.secondary,
                                                                                                  // color: Colors.deepPurple,
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          : const SizedBox.shrink(),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    // => showDialog(
                                                                    //   context: context,
                                                                    //   builder: (context) {
                                                                    //     bool isAutoPlayON = (E["AutoSave"] == "Y");
                                                                    //     return AlertDialog(
                                                                    //       backgroundColor: AppTheme.secondary,
                                                                    //       title: Column(
                                                                    //         children: [
                                                                    //           Align(
                                                                    //             alignment: Alignment.centerLeft,
                                                                    //             child: Text(
                                                                    //               isAutoPlayON ? "Turn-Off AutoPlay Video?" : "AutoPlay Video?",
                                                                    //               style: AppTheme.t6TitleSmall(context)?.copyWith(
                                                                    //                 letterSpacing: 1,
                                                                    //                 fontWeight: FontWeight.w600,
                                                                    //                 color: AppTheme.onPrimary,
                                                                    //                 // color: Colors.deepPurple,
                                                                    //               ),
                                                                    //             ),
                                                                    //           ),
                                                                    //           Divider(thickness: 2.75, color: AppTheme.onSecondary),
                                                                    //         ],
                                                                    //       ),
                                                                    //       content: RichText(
                                                                    //         textAlign: TextAlign.justify,
                                                                    //         text: TextSpan(
                                                                    //           recognizer: TapGestureRecognizer()
                                                                    //             ..onTap = () {
                                                                    //               Navigator.of(context).push(
                                                                    //                 PageAnimationTransition(
                                                                    //                   pageAnimationType: RightToLeftTransition(),
                                                                    //                   page: const TCPrivacyPolicy(),
                                                                    //                 ),
                                                                    //               );
                                                                    //             },
                                                                    //           text: isAutoPlayON
                                                                    //               ? "AutoPlay Feature helps you to Auto Start the Youtube Video as soon as you Go to Section Screen. Do you want to Turn it ${isAutoPlayON ? "ON" : "OFF"}?"
                                                                    //               : "AutoPlay Feature helps you to Auto Start the Youtube Video as soon as you Go to Section Screen. Do you want to Turn it ON?",
                                                                    //           style: AppTheme.t8LabelMedium(context)?.copyWith(
                                                                    //             letterSpacing: 1,
                                                                    //             fontWeight: FontWeight.w600,
                                                                    //             color: AppTheme.onSecondary,
                                                                    //             // color: Colors.deepPurple,
                                                                    //           ),
                                                                    //         ),
                                                                    //       ),
                                                                    //       actions: [
                                                                    //         Row(
                                                                    //           mainAxisAlignment: MainAxisAlignment.end,
                                                                    //           children: [
                                                                    //             ElevatedButton(
                                                                    //               onPressed: () async {
                                                                    //                 //TODO: Firebase AutoPlay Config.
                                                                    //                 FirebaseFirestore.instance
                                                                    //                     .collection("StudentDB")
                                                                    //                     .doc(UserData.googleUserEmail)
                                                                    //                     .collection("Current Joined")
                                                                    //                     .doc(E["Title"])
                                                                    //                     .update({"AutoPlay": isAutoPlayON ? "N" : "Y"})
                                                                    //                     .then(
                                                                    //                       (value) =>
                                                                    //                           setState(() => isAutoPlayON = E["AutoPlay"] == "Y"),
                                                                    //                     )
                                                                    //                     .then(
                                                                    //                       (value) => ShowSnackInfo.success(
                                                                    //                         contentText:
                                                                    //                             "AutoPlay Turned ${(isAutoPlayON) ? "OFF" : "ON"} Successfully.",
                                                                    //                       ).show(context),
                                                                    //                     )
                                                                    //                     .then((value) => Navigator.pop(context));
                                                                    //               },
                                                                    //               clipBehavior: Clip.antiAlias,
                                                                    //               child: Text(
                                                                    //                 isAutoPlayON ? "Turn Off" : "Yes, Turn On",
                                                                    //                 // Sign-In "",
                                                                    //                 style: AppTheme.t7LabelLarge(context)?.copyWith(
                                                                    //                   letterSpacing: 1,
                                                                    //                   fontWeight: FontWeight.bold,
                                                                    //                   color: AppTheme.error,
                                                                    //                   // color: Colors.deepPurple,
                                                                    //                 ),
                                                                    //               ),
                                                                    //             ),
                                                                    //           ],
                                                                    //         ),
                                                                    //       ],
                                                                    //     );
                                                                    //   },
                                                                    // ),
                                                                    child: Card(
                                                                      color: Colors.white,
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(left: 7.5),
                                                                              child: Text(
                                                                                "AutoSave after: ${E["AutoSave"]}%",
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
                                                                              child: Icon(Icons.auto_mode, color: AppTheme.onPrimary),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 5.0),
                                                                  //TODO: DELETE COURSE
                                                                  GestureDetector(
                                                                    onTap: () async => showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                          backgroundColor: AppTheme.secondary,
                                                                          title: Column(
                                                                            children: [
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  "Rolling Out?...",
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
                                                                                  "Please Confirm to Delete/ Roll-Out this Course: ${E["Title"].toString()} from the 'My Courses' and revert all the Progress Store Till now.",
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
                                                                                    Navigator.pop(context);
                                                                                    setState(() => isDeleted = true);
                                                                                    await FirebaseControls.deleteCourseFromFirebaseStudentDBCurrentJoined(
                                                                                          E["Title"],
                                                                                        )
                                                                                        .then(
                                                                                          (value) =>
                                                                                              FirebaseControls.deleteUserAndProgressFromFirebaseCourseDB(
                                                                                                widget.courseData["Title"],
                                                                                              ).then(
                                                                                                (value) => ShowSnackInfo.error(
                                                                                                  contentText: "Rolled Out Successfully...",
                                                                                                ).show(context),
                                                                                                // ScaffoldMessenger.of(context)
                                                                                                //     .showSnackBar(
                                                                                                //   SnackBar(
                                                                                                //     backgroundColor:
                                                                                                //         Colors.green.shade700,
                                                                                                //     showCloseIcon: true,
                                                                                                //     content: Text(
                                                                                                //       "Rolled-Out Successfully...",
                                                                                                //       style:
                                                                                                //           AppTheme.t6TitleSmall(
                                                                                                //                   context)
                                                                                                //               ?.copyWith(
                                                                                                //         color: AppTheme.onError,
                                                                                                //         letterSpacing: 1.2,
                                                                                                //         fontWeight:
                                                                                                //             FontWeight.bold,
                                                                                                //       ),
                                                                                                //     ),
                                                                                                //   ),
                                                                                                // );
                                                                                              ),
                                                                                        )
                                                                                        .then((value) {
                                                                                          Navigator.pop(context);
                                                                                          Navigator.pop(context);
                                                                                        });
                                                                                    debugPrint("Deleted");
                                                                                  },
                                                                                  child: Text(
                                                                                    "Yes",
                                                                                    style: AppTheme.t7LabelLarge(context)?.copyWith(
                                                                                      letterSpacing: 1,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: AppTheme.error,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                    child: Card(
                                                                      color: Colors.white,
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(left: 7.5),
                                                                              child: Text(
                                                                                "Roll out from this Course",
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
                                                                              child: Icon(Icons.folder_delete_outlined, color: AppTheme.onError),
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
                                                            style: AppTheme.t4TitleLarge(context)!.copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              letterSpacing: 1,
                                                              // fontSize: 20.0,
                                                              color: AppTheme.onPrimary,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Card(
                                                              child: ListView.builder(
                                                                shrinkWrap: true,
                                                                physics: const ClampingScrollPhysics(),
                                                                itemCount: E["Id"].length,
                                                                itemBuilder: (BuildContext context, sectionsForIndex) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                                                                    child: Column(
                                                                      children: [
                                                                        (sectionsForIndex == 0)
                                                                            ? const SizedBox.shrink()
                                                                            : Divider(thickness: 2.0, color: AppTheme.secondary),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(7.5, 0.0, 7.5, 0.0),
                                                                          child: ListTile(
                                                                            onTap: () async {
                                                                              if (!(sectionsForIndex != 0 &&
                                                                                  int.parse(E["Progress"][sectionsForIndex - 1]) != 100)) {
                                                                                routeToYoutubePlayer(E, sectionsForIndex);
                                                                              } else {
                                                                                debugPrint("Not....");
                                                                              }
                                                                            },
                                                                            title: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: SingleChildScrollView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Text(
                                                                                      E["LT"][sectionsForIndex].toString(),
                                                                                      textAlign: TextAlign.left,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: AppTheme.t4TitleLarge(context)!.copyWith(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        // fontSize: 22.50,
                                                                                        color: AppTheme.primary,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            subtitle: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.access_time,
                                                                                      size: AppTheme.t5TitleMedium(context)!.fontSize! + 1,
                                                                                      color: AppTheme.primary,
                                                                                    ),
                                                                                    const SizedBox(width: 2.5),
                                                                                    Text(
                                                                                      secToHHMMSS(
                                                                                        int.parse(E["Length"][sectionsForIndex]),
                                                                                      ).toString(),
                                                                                      textAlign: TextAlign.left,
                                                                                      style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        letterSpacing: 1.5,
                                                                                        color: AppTheme.primary,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                (sectionsForIndex != 0 &&
                                                                                        int.parse(E["Progress"][sectionsForIndex - 1]) != 100)
                                                                                    ? Icon(Icons.lock, color: AppTheme.primary)
                                                                                    : (int.parse(E["Progress"][sectionsForIndex]) != 100)
                                                                                    ? Text(
                                                                                        (int.parse(E["Progress"][sectionsForIndex]) == 0)
                                                                                            ? "Start" // Now"
                                                                                            : (int.parse(E["Progress"][sectionsForIndex]) == 100)
                                                                                            ? "Completed"
                                                                                            : "${E["Progress"][sectionsForIndex]}%",
                                                                                        textAlign: TextAlign.left,
                                                                                        style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                                                          fontWeight: FontWeight.w700,
                                                                                          letterSpacing: 1.0,
                                                                                          color: Colors.green.shade800,
                                                                                        ),
                                                                                      )
                                                                                    : Icon(Icons.done, color: Colors.green.shade800),
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
                        },
                      ),
              ),
              Builder(
                builder: (context) => const AppbarCard(
                  adc: null,
                  titleAppBar: "My Courses",
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
