import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../../../app_info/terms_conditions_privacy.dart';
import '../../../../auth_logic/firebase_controls.dart';
import '../../../../core/data_model/user_data_model.dart';
import '../../../../core/constants.dart';
import '../../../../core/theme_set/snack_theme.dart';
import '../../../../core/theme_set/theme_colors.dart';
import 'constants_widget.dart';

late TextEditingController? courseTitle;
late TextEditingController? courseNoV;
late TextEditingController? courseDescription;

late TextEditingController? indexedVideoTitle;
late TextEditingController? indexedVideoID;

int currentIndexForm = -1;
bool currentIndexIsSaved = false;
bool formCompleted = false;

bool resetAllField = true;

List<dynamic> cardText1 = [
  'Title of the Course: ',
  "Eg. Artificial Intelligence and Machine Learning | Part 1 : Introduction",
  'Enter the Title of The Course. It is the First Impression of the Course. Note: Every Title should be Unique.',
  Icons.title,
  false,
];
List<dynamic> cardText2 = [
  'Description of the Course:',
  "Eg. A Professional Course on Artificial Intelligence and Machine Learning.",
  'Enter the description of The Course. Describe the Course in its Overall Outcome to the Student. It helps the Student to recognize the Course Outcomes More Easier.',
  Icons.info_outline_rounded,
  false,
];
List<dynamic> cardText3 = [
  'Sub-Section Counter:',
  "Eg. 2,5,7, etc",
  'Enter the Number of Steps/Sections,i.e., Youtube Videos from which this Course will be Structured. This is for Making the Layout of Youtube Videos URL in the Next Step of Creating Course.',
  Icons.numbers,
  false,
];

class CardEditorTitle extends StatelessWidget {
  const CardEditorTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(48.0, 8.0, 25.0, 0.0),
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: AppTheme.t6TitleSmall(context)?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 01.5, color: AppTheme.onPrimary),
      ),
    );
  }
}

class AddCourseToCloudDatabase extends StatefulWidget {
  const AddCourseToCloudDatabase({super.key});

  @override
  State<AddCourseToCloudDatabase> createState() => _AddCourseToCloudDatabaseState();
}

class _AddCourseToCloudDatabaseState extends State<AddCourseToCloudDatabase> {
  Future<void> confirmedToAddCourseToHiveAndCallAddToFirebase() async {
    if (courseTitle?.text != "") {
      Map<String, dynamic> makeMapOfCourseData = {
        "Id": List.empty(growable: true),
        "Length": List.empty(growable: true),
        "LT": List.empty(growable: true),
        "Title": courseTitle?.text,
        "Description": courseDescription?.text,
        "Author": UserData.googleUserName,
        // "Author": userGoogleAcc?.displayName,
        "Users": List.empty(growable: true),
        "Progress": List.empty(growable: true),
      };
      debugPrint(makeMapOfCourseData.toString());
      try {
        await FirebaseControls.addCourseToFirebaseCourseDB(context, makeMapOfCourseData["Title"], makeMapOfCourseData);
        debugPrint("Data added");
      } catch (exp) {
        debugPrint("$exp");
      }
    }
  }

  @override
  void initState() {
    currentIndexForm = -1;
    currentIndexIsSaved = false;
    formCompleted = false;
    courseTitle = TextEditingController();
    courseNoV = TextEditingController();
    courseDescription = TextEditingController();
    indexedVideoTitle = TextEditingController();
    indexedVideoID = TextEditingController();
    super.initState();
  }

  void resetAllTextEditingField() {
    setState(() {
      courseTitle!.clear();
      courseDescription!.clear();
      indexedVideoTitle!.clear();
      indexedVideoID!.clear();
      courseNoV!.clear();
      resetAllField = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndexForm != -1 && currentIndexForm >= 0) {
          setState(() => currentIndexForm--);
          return false;
        } else {
          if (!(courseTitle!.text.isNotEmpty || courseDescription!.text.isNotEmpty || courseNoV!.text.isNotEmpty)) {
            return true;
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppTheme.secondary,
                  title: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Are you sure, Go Back?",
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
                        ..onTap = () => Navigator.of(
                          context,
                        ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const TCPrivacyPolicy())),
                      text: "You will lose all the Data and Course Addition Step.\nAnd You have to add all the Information/Data Again.",
                      style: AppTheme.t8LabelMedium(context)?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w600, color: AppTheme.onSecondary),
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "No",
                            style: AppTheme.t6TitleSmall(
                              context,
                            )?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w600, color: AppTheme.onSecondary),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              formCompleted = false;
                              courseTitle?.clear();
                              courseDescription?.clear();
                              indexedVideoTitle?.clear();
                              indexedVideoID?.clear();
                              courseNoV?.clear();
                              resetAllField = true;
                              formCompleted = false;
                            });
                            Navigator.pop(context);
                          },
                          clipBehavior: Clip.antiAlias,
                          child: Text(
                            "Yes",
                            style: AppTheme.t6TitleSmall(context)?.copyWith(letterSpacing: 1, fontWeight: FontWeight.bold, color: AppTheme.error),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.pCon,
        body: SafeArea(
          child: Stack(
            children: [
              const BackGroundWithGradientEffect(),
              Padding(
                padding: const EdgeInsets.only(top: 65.0),
                child: (currentIndexForm == -1)
                    ? ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          const SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, bottom: 8.0, right: 25.0),
                            child: Card(
                              elevation: 5.0,
                              margin: const EdgeInsets.symmetric(vertical: 4.25),
                              color: AppTheme.primary,
                              child: Column(
                                children: [
                                  CardEditorTitle(text: cardText1[0].toString()),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 25.0, top: 8.0, bottom: 8.0),
                                    child: TextFormField(
                                      controller: courseTitle,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      autocorrect: false,
                                      textCapitalization: TextCapitalization.sentences,
                                      style: CustomStyleForTextFormField.formFieldTextStyle(context),
                                      decoration: CustomStyleForTextFormField.formFieldDecoration(context, cardText1[3], cardText1[1].toString()),
                                      minLines: 1,
                                      maxLines: 3,
                                      onChanged: (t) => setState(() => debugPrint("Title Changed")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, bottom: 8.0, right: 25.0),
                            child: Card(
                              elevation: 5.0,
                              margin: const EdgeInsets.symmetric(vertical: 4.25),
                              color: AppTheme.primary,
                              child: Column(
                                children: [
                                  CardEditorTitle(text: cardText3[0].toString()),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 25.0, top: 8.0, bottom: 8.0),
                                    child: TextFormField(
                                      controller: courseNoV,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textCapitalization: TextCapitalization.sentences,
                                      style: CustomStyleForTextFormField.formFieldTextStyle(context),
                                      decoration: CustomStyleForTextFormField.formFieldDecoration(context, cardText3[3], cardText3[1].toString()),
                                      onChanged: (t) => setState(() => debugPrint("No. of Videos Changed")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, bottom: 8.0, right: 25.0),
                            child: Card(
                              elevation: 5.0,
                              margin: const EdgeInsets.symmetric(vertical: 4.25),
                              color: AppTheme.primary,
                              child: Column(
                                children: [
                                  CardEditorTitle(text: cardText2[0].toString()),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 25.0, top: 8.0, bottom: 8.0),
                                    child: TextFormField(
                                      controller: courseDescription,
                                      keyboardType: TextInputType.multiline,
                                      autocorrect: false,
                                      textCapitalization: TextCapitalization.sentences,
                                      textInputAction: TextInputAction.next,
                                      style: CustomStyleForTextFormField.formFieldTextStyle(context),
                                      decoration: CustomStyleForTextFormField.formFieldDecoration(context, cardText2[3], cardText2[1].toString()),
                                      minLines: 1,
                                      maxLines: 7,
                                      onChanged: (t) => setState(() => debugPrint("Description Changed")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, bottom: 8.0, right: 25.0),
                            child: Card(
                              elevation: 5.0,
                              margin: const EdgeInsets.symmetric(vertical: 4.25),
                              color: AppTheme.primary,
                              child: Column(
                                children: [
                                  const CardEditorTitle(text: "Author of this Course:"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 25.0, top: 8.0, bottom: 8.0),
                                    child: TextFormField(
                                      autocorrect: false,
                                      readOnly: true,
                                      style: CustomStyleForTextFormField.formFieldTextStyle(context),
                                      decoration:
                                          CustomStyleForTextFormField.formFieldDecoration(
                                            context,
                                            Icons.person_pin_outlined,
                                            UserData.googleUserName,
                                          ).copyWith(
                                            helperMaxLines: 10,
                                            helperStyle: AppTheme.t9LabelSmall(context)?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'SourGummy',
                                              letterSpacing: 1.5,
                                              color: AppTheme.onPrimary,
                                            ),
                                            helperText: "The Author Name Tag of the Course. From your Goggle Account.",
                                            suffixIcon: Icon(Icons.edit_off_outlined, color: AppTheme.primary),
                                          ),
                                      minLines: 1,
                                      maxLines: 7,
                                      onChanged: (t) => setState(() => debugPrint("Description Changed")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot<dynamic>>(
                            stream: FirebaseControls.readAllCourse(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 25.0, bottom: 8.0 + 60.0, right: 25.0),
                                child: Card(
                                  color: AppTheme.primary,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 7.50, vertical: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (courseTitle!.text.isEmpty && courseNoV!.text.isEmpty) {
                                            //TODO: BOTH Empty
                                            ShowSnackInfo.error(contentText: "Title and Number of Videos are Required.").show(context);
                                          } else if (courseTitle!.text.isEmpty) {
                                            //TODO: Title Empty
                                            ShowSnackInfo.error(contentText: "Course Title is Required.").show(context);
                                          } else if (courseNoV!.text.isEmpty) {
                                            //TODO: No. of Video Empty.
                                            ShowSnackInfo.error(contentText: "Number of Videos is Required.").show(context);
                                          } else {
                                            if (snapshot.hasData) {
                                              bool checkCourseTitleAlreadyExist() {
                                                List<String> allTiIle = List.empty(growable: true);
                                                for (int i = 0; i < snapshot.data.docs.length; i++) {
                                                  // TODO : Each Document
                                                  dynamic eachCourse = snapshot.data.docs[i];
                                                  allTiIle.add(eachCourse["Title"].toString());
                                                  if (allTiIle.contains(courseTitle!.text.toString())) {
                                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                    (eachCourse["Author"].toString().trim() != UserData.googleUserName)
                                                        ? ShowSnackInfo.error(
                                                            contentText:
                                                                "Course Already Exists...\n'${eachCourse["Title"]}' by ${eachCourse["Author"]}",
                                                            duration: const Duration(days: 1),
                                                          ).show(context)
                                                        : ShowSnackInfo.success(
                                                            contentText: "Course Already Exists...\n'${eachCourse["Title"]}' - in Editing",
                                                          ).show(context);
                                                    if (eachCourse["Author"].trim() != UserData.googleUserName) {
                                                      courseTitle!.clear();
                                                    } else {
                                                      return false;
                                                    }
                                                    return true;
                                                  }
                                                }
                                                return false;
                                              }

                                              if (checkCourseTitleAlreadyExist()) {
                                              } else {
                                                setState(() {
                                                  if (int.parse(courseNoV!.text.toString()) > 0) {
                                                    currentIndexForm++;
                                                  } else {}
                                                });
                                              }
                                            }
                                          }
                                        },
                                        child: Card(
                                          color: AppTheme.onPrimary,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 7.5),
                                                  child: Text(
                                                    "Continue to Next Step",
                                                    style: AppTheme.t5TitleMedium(
                                                      context,
                                                    )!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0, color: AppTheme.primary),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                color: AppTheme.primary,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Icon(Icons.navigate_next, color: AppTheme.onPrimary),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : MakeCourseStructure(numberVid: int.parse(courseNoV!.text.toString())),
              ),
              Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 010.0, left: 10.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (currentIndexForm != -1 && currentIndexForm >= 0) {
                                        setState(() => currentIndexForm--);
                                      } else {
                                        (!(courseTitle!.text.isNotEmpty || courseDescription!.text.isNotEmpty || courseNoV!.text.isNotEmpty))
                                            ? Navigator.pop(context)
                                            : showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor: AppTheme.secondary,
                                                    title: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            "Are you sure, Go Back?",
                                                            style: AppTheme.t6TitleSmall(
                                                              context,
                                                            )?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w600, color: AppTheme.onPrimary),
                                                          ),
                                                        ),
                                                        Divider(thickness: 2.75, color: AppTheme.onSecondary),
                                                      ],
                                                    ),
                                                    content: Text(
                                                      "You will lose all the Data in this Course Addition Step.\nAnd You have to add all the Information/Data Again.",
                                                      textAlign: TextAlign.justify,
                                                      style: AppTheme.t8LabelMedium(
                                                        context,
                                                      )?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w600, color: AppTheme.onSecondary),
                                                    ),
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: Text(
                                                              "No",
                                                              style: AppTheme.t6TitleSmall(
                                                                context,
                                                              )?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w600, color: AppTheme.onSecondary),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              setState(() {
                                                                formCompleted = false;
                                                                courseTitle?.clear();
                                                                courseDescription?.clear();
                                                                indexedVideoTitle?.clear();
                                                                indexedVideoID?.clear();
                                                                courseNoV?.clear();
                                                                resetAllField = true;
                                                                formCompleted = false;
                                                              });
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                            },
                                                            clipBehavior: Clip.antiAlias,
                                                            child: Text(
                                                              "Yes",
                                                              style: AppTheme.t6TitleSmall(
                                                                context,
                                                              )?.copyWith(letterSpacing: 1, fontWeight: FontWeight.bold, color: AppTheme.error),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                      }
                                    },
                                    child: Card(
                                      elevation: 5.0,
                                      child: SizedBox(
                                        height: Theme.of(context).textTheme.displayMedium?.fontSize,
                                        width: Theme.of(context).textTheme.displayMedium?.fontSize,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(child: Icon(Icons.arrow_back, color: AppTheme.primary)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Card(
                                    elevation: 5.0,
                                    child: SizedBox(
                                      height: Theme.of(context).textTheme.displayMedium?.fontSize,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(18.0, 10.0, 15.0, 10.0),
                                        child: Center(
                                          child: Text(
                                            "Add New Course",
                                            style: AppTheme.t6TitleSmall(context)?.copyWith(
                                              fontFamily: 'SourGummy',
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              (courseTitle!.text.isNotEmpty ||
                                      courseDescription!.text.isNotEmpty ||
                                      courseNoV!.text.isNotEmpty ||
                                      indexedVideoTitle!.text.isNotEmpty ||
                                      indexedVideoID!.text.isNotEmpty)
                                  ? GestureDetector(
                                      onTap: () {
                                        currentIndexForm = -1;
                                        resetAllTextEditingField();
                                        setState(() {});
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
                                                  child: Icon(
                                                    Icons.refresh,
                                                    // size: AppTheme.t6TitleSmall(context)!.fontSize,
                                                    color: AppTheme.onPrimary,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                              Align(
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
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          tooltip: "HELP",
          foregroundColor: AppTheme.primary,
          backgroundColor: AppTheme.onPrimary,
          onPressed: () => Navigator.of(
            context,
          ).push(PageAnimationTransition(page: const ViewMoreInformationForAddingCourse(), pageAnimationType: RightToLeftTransition())),
          child: Icon(Icons.question_mark, weight: 2.0, grade: 2.0, color: AppTheme.primary),
        ),
      ),
    );
  }
}

class CardForEachInformationInReview extends StatelessWidget {
  const CardForEachInformationInReview({super.key, required this.informationText, required this.primaryText});

  final String informationText;
  final String primaryText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.50),
      child: Card(
        color: AppTheme.primary,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 12.5, 8.0, 12.5),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      primaryText,
                      style: AppTheme.t5TitleMedium(
                        context,
                      )?.copyWith(fontWeight: FontWeight.bold, fontFamily: 'SourGummy', letterSpacing: 01.5, color: AppTheme.onPrimary),
                    ),
                  ),
                ),
                Divider(color: AppTheme.onPrimary, thickness: 2.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 17.50),
                    child: Text(
                      informationText,
                      style: AppTheme.t5TitleMedium(
                        context,
                      )?.copyWith(fontWeight: FontWeight.bold, fontFamily: 'SourGummy', letterSpacing: 01.5, color: AppTheme.onPrimary),
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

class MakeCourseStructure extends StatefulWidget {
  final int numberVid;

  const MakeCourseStructure({super.key, required this.numberVid});

  @override
  State<MakeCourseStructure> createState() => _MakeCourseStructureState();
}

class _MakeCourseStructureState extends State<MakeCourseStructure> {
  final String apiKey = 'AIzaSyCSOVyko1jhvg_TcCEvU7wy-3AzgHjQZMY'; // Replace with your YouTube API key
  String? _extractVideoId(String url) {
    RegExp regExp = RegExp(r'^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/|shorts\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*');
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  Future<bool> _fetchVideoDetails(int currentIterationIndex) async {
    try {
      final url = indexedVideoID!.text.trim();
      if (url.isEmpty) throw 'Please enter a YouTube URL';
      final videoId = _extractVideoId(url);
      if (videoId == null) throw 'Invalid YouTube URL';
      final response = await http.get(Uri.parse('https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=$videoId&key=$apiKey'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          final duration = data['items'][0]['contentDetails']['duration'];
          final parsedDuration = _parseDuration(duration);
          setState(() {
            vidLengthControllerList[currentIterationIndex] = parsedDuration.toString();
            vidControllerList[currentIterationIndex] = videoId.toString();
          });
        } else {
          throw 'Video not found';
        }
      } else {
        throw 'Failed to fetch video details: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return (vidLengthControllerList[currentIterationIndex] != "0" || vidControllerList[currentIterationIndex] != "VideoAt$currentIterationIndex");
  }

  String _parseDuration(String iso8601Duration) {
    RegExp regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    Match? match = regex.firstMatch(iso8601Duration);

    if (match != null) {
      int hours = int.tryParse(match.group(1) ?? '0') ?? 0;
      int minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
      int seconds = int.tryParse(match.group(3) ?? '0') ?? 0;
      int total = seconds + 60 * minutes + 60 * 60 * hours;
      return total.toString();
    }
    return 'Unknown duration';
  }

  @override
  void initState() {
    if (resetAllField) {
      vidControllerList = List.generate(widget.numberVid, (index) => "VideoAt$index");
      vTControllerList = List.generate(widget.numberVid, (index) => "Lecture no. $index");
      vidLengthControllerList = List.generate(widget.numberVid, (index) => "0");
      for (int i = 0; i < indexedSavedController.length; i++) {
        setState(() {
          indexedSavedController[i] = false;
        });
      }
      resetAllField = false;
    }
    super.initState();
  }

  late List<bool> step = List.generate(widget.numberVid + 1, (index) => (index == 0) ? true : false);

  late List<String> vidControllerList = List.generate(widget.numberVid, (index) => "VideoAt$index");
  late List<String> vTControllerList = List.generate(widget.numberVid, (index) => "Lecture no. $index");
  late List<String> vidLengthControllerList = List.generate(widget.numberVid, (index) => "0");
  late List<bool> indexedSavedController = List.generate(widget.numberVid, (index) => false);

  // late List<String> vidControllerList;
  // late List<String> vTControllerList;
  // late List<String> vidLengthControllerList;
  // late List<bool> indexedSavedController;

  Future<void> confirmedToAddCourseToHiveAndCallAddToFirebase() async {
    if (courseTitle!.text != "") {
      Map<String, dynamic> makeMapOfCourseData = {
        "Id": vidControllerList,
        "Length": vidLengthControllerList,
        "LT": vTControllerList,
        "Title": courseTitle!.text,
        "Description": courseDescription!.text,
        "Author": UserData.googleUserName,
        // "Author": userGoogleAcc?.displayName,
        "Users": List.empty(growable: true),
        "Progress": List.empty(growable: true),
      };
      debugPrint("$makeMapOfCourseData");
      try {
        await FirebaseControls.addCourseToFirebaseCourseDB(context, makeMapOfCourseData["Title"], makeMapOfCourseData);
        debugPrint("Data added");
      } catch (exp) {
        debugPrint("$exp");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.numberVid + 100,
      itemBuilder: (BuildContext context, iterator) {
        int indexer = currentIndexForm + 1;
        return (currentIndexForm == iterator && currentIndexForm < widget.numberVid)
            ? Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    (indexedSavedController[iterator])
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Card(
                                  color: AppTheme.pCon,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 20.0),
                                                child: SingleChildScrollView(
                                                  physics: const ClampingScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  child: Container(
                                                    margin: const EdgeInsetsDirectional.fromSTEB(00.0, 1.0, 20.0, 01.0),
                                                    child: Text(
                                                      "Review: Part ${currentIndexForm + 1}",
                                                      style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                        fontSize: 2.5 + AppTheme.t5TitleMedium(context)!.fontSize!,
                                                        color: AppTheme.primary.withValues(alpha: 0.85),
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => setState(() {
                                                debugPrint("$iterator");
                                                indexedSavedController[iterator] = !indexedSavedController[iterator];
                                                formCompleted = false;
                                              }),
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                margin: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 20.0, 7.50),
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                  color: AppTheme.primary, //Colors.blueGrey,
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 22.50,
                                                  color: AppTheme.onPrimary, //Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(padding: EdgeInsets.all(5.0)),
                                        CardForEachInformationInReview(primaryText: "Title for Part", informationText: vTControllerList[iterator]),
                                        CardForEachInformationInReview(
                                          primaryText: "Youtube ID-URL:",
                                          informationText: "Youtube URL Status:  Valid.\n\nYoutube Video Credentials: ${vidControllerList[iterator]}",
                                        ),
                                        CardForEachInformationInReview(
                                          primaryText: "Video Duration:",
                                          informationText: secToHHMMSS(int.parse(vidLengthControllerList[iterator])),
                                        ),
                                        (currentIndexForm != widget.numberVid - 1)
                                            ? Divider(height: 50.0, thickness: 3.0, color: AppTheme.primary)
                                            : const SizedBox(width: 0.0, height: 0.0),
                                        (currentIndexForm == widget.numberVid - 1 && formCompleted)
                                            ? const SizedBox(width: 0, height: 0)
                                            : Padding(
                                                padding: const EdgeInsets.fromLTRB(25.0, 2.50, 25.0, 8.0),
                                                child: GestureDetector(
                                                  onTap: () => setState(() {
                                                    if (currentIndexForm < widget.numberVid) {
                                                      indexedVideoTitle!.clear();
                                                      indexedVideoID!.clear();
                                                      currentIndexForm++;
                                                      debugPrint("$iterator");
                                                    }
                                                  }),
                                                  child: Card(
                                                    color: AppTheme.primary,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Save and Next",
                                                            style: AppTheme.t5TitleMedium(
                                                              context,
                                                            )?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 01.5, color: AppTheme.onPrimary),
                                                          ),
                                                          const Expanded(child: SizedBox(width: 7.5)),
                                                          Card(
                                                            color: AppTheme.onPrimary,
                                                            child: SizedBox(
                                                              height: 35.0,
                                                              width: 35.0,
                                                              child: Icon(Icons.navigate_next, size: 25.0, color: AppTheme.primary),
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
                                (currentIndexForm == widget.numberVid - 1)
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(25.0, 25.00, 25.0, 8.0),
                                        child: GestureDetector(
                                          onTap: () async => await confirmedToAddCourseToHiveAndCallAddToFirebase()
                                              .then((value) => ShowSnackInfo.success(contentText: "Course Created Successfully...").show(context))
                                              .then((value) => Navigator.pop(context)),
                                          child: Card(
                                            color: AppTheme.primary,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Create Course",
                                                      style: AppTheme.t5TitleMedium(context)?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'SourGummy',
                                                        letterSpacing: 01.5,
                                                        color: AppTheme.onPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40.0,
                                                    child: Card(
                                                      color: AppTheme.onPrimary,
                                                      child: SizedBox(
                                                        height: 35.0,
                                                        width: 35.0,
                                                        child: Icon(Icons.navigate_next, size: 30.0, color: AppTheme.primary),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(height: 0.0, width: 0.0),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 15.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0, bottom: 8.0, right: 25.0),
                                child: Card(
                                  elevation: 5.0,
                                  margin: const EdgeInsets.symmetric(vertical: 4.25),
                                  color: AppTheme.primary,
                                  child: Column(
                                    children: [
                                      CardEditorTitle(text: "Title of the Part $indexer:"),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 25.0, top: 8.0, bottom: 8.0),
                                        child: TextFormField(
                                          controller: indexedVideoTitle,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          minLines: 1,
                                          maxLines: 5,
                                          style: CustomStyleForTextFormField.formFieldTextStyle(context),
                                          decoration:
                                              CustomStyleForTextFormField.formFieldDecoration(
                                                context,
                                                Icons.title,
                                                "Eg. Introduction, Objectives, etc",
                                              ).copyWith(
                                                helperMaxLines: 5,
                                                helperStyle: AppTheme.t9LabelSmall(
                                                  context,
                                                )?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppTheme.onPrimary),
                                                filled: true,
                                                helperText: "The Title of the Current Course Step, for Student's Conveniences.",
                                              ),
                                          onChanged: (val1) => setState(() {}),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0, bottom: 8.0, right: 25.0),
                                child: Card(
                                  elevation: 5.0,
                                  margin: const EdgeInsets.symmetric(vertical: 4.25),
                                  color: AppTheme.primary,
                                  child: Column(
                                    children: [
                                      CardEditorTitle(text: "Youtube URL of the Part $indexer:"),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 25.0, top: 8.0, bottom: 8.0),
                                        child: TextFormField(
                                          controller: indexedVideoID,
                                          textInputAction: TextInputAction.done,
                                          autocorrect: false,
                                          keyboardType: TextInputType.url,
                                          minLines: 1,
                                          maxLines: 7,
                                          style: CustomStyleForTextFormField.formFieldTextStyle(context),
                                          decoration:
                                              CustomStyleForTextFormField.formFieldDecoration(
                                                context,
                                                Icons.link,
                                                "Eg. http://www.youtube.com/watch?i=ABC1DEF2GHI3..., etc",
                                              ).copyWith(
                                                helperMaxLines: 10,
                                                helperStyle: AppTheme.t9LabelSmall(context)?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SourGummy',
                                                  letterSpacing: 1.5,
                                                  color: AppTheme.onPrimary,
                                                ),
                                                filled: true,
                                                helperText:
                                                    "The U.R.L. of the Youtube Videos for this Part. For more go to '?' Help", // Note: This needs to be Verified Strictly. if a Video is able to be streamed in any Browser, that U.R.L. will be considered as Valid.",
                                              ),
                                          onChanged: (val1) => setState(() {}),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              (indexedVideoID!.text.isNotEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20.0, //110.0,
                                        left: 125.0,
                                        bottom: 8.0,
                                        right: 125.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (indexedVideoID!.text.toString() != "" && indexedVideoTitle!.text.toString() != "") {
                                            bool durationAndURLRequest = await _fetchVideoDetails(iterator);
                                            if (durationAndURLRequest) {
                                              setState(() {
                                                vTControllerList[iterator] = indexedVideoTitle!.text.toString();
                                                indexedSavedController[iterator] = !indexedSavedController[iterator];
                                              });
                                              setState(() {
                                                bool isSaved = false;
                                                for (int i = 0; i < indexedSavedController.length; i++) {
                                                  if (indexedSavedController[i]) {
                                                    isSaved = true;
                                                    debugPrint(isSaved.toString());
                                                  } else {
                                                    isSaved = false;
                                                    break;
                                                  }
                                                }
                                                if (isSaved || indexedSavedController[widget.numberVid - 1]) {
                                                  formCompleted = true;
                                                }
                                              });
                                              debugPrint("$iterator");
                                              debugPrint("$vTControllerList");
                                              debugPrint("$vidControllerList");
                                              debugPrint("$vidLengthControllerList");
                                              debugPrint("$indexedSavedController");
                                            } else {
                                              debugPrint("\n\n\n\n\nERROR\n\n\n\n\n");
                                              ShowSnackInfo.error(
                                                contentText:
                                                    "Something went Wrong...The U.R.L. can not be reached. Please try again..or check the Internet Connections.",
                                              ).show(context);
                                              indexedVideoID!.clear();
                                            }
                                          } else {
                                            debugPrint("No Data filled");
                                          }
                                        },
                                        child: Card(
                                          color: AppTheme.primary,
                                          elevation: 5.0,
                                          margin: const EdgeInsets.symmetric(vertical: 4.25, horizontal: 5.0),
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(7.50, 12.50, 7.50, 12.5),
                                            alignment: Alignment.topLeft,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "SAVE",
                                                style: AppTheme.t4TitleLarge(context)?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SourGummy',
                                                  letterSpacing: 02.5,
                                                  color: AppTheme.onPrimary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(width: 0.0, height: 0.0),
                            ],
                          ),
                  ],
                ),
              )
            : const SizedBox(height: 0, width: 0);
      },
    );
  }
}
