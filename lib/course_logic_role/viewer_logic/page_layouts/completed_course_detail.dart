import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dock_learner/auth_logic/firebase_controls.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../../../core/data_model/user_data_model.dart';
import '../../../core/constants.dart';
import '../../../core/home_screen_widgets.dart';
import '../../../core/loading_shimmers.dart';
import '../../../core/theme_set/snack_theme.dart';
import '../../../core/theme_set/theme_colors.dart';
import '../../../core/thumbnail_extract_widget.dart';
import '../media_player_lectures/media_player_youtube.dart';

class ViewDetailsCompletedCourses extends StatefulWidget {
  const ViewDetailsCompletedCourses({super.key, required this.cTitle});

  final String cTitle;

  @override
  State<ViewDetailsCompletedCourses> createState() => _ViewDetailsCompletedCoursesState();
}

class _ViewDetailsCompletedCoursesState extends State<ViewDetailsCompletedCourses> {
  bool isGenerating = false;
  late final Box box;

  Future<void> generateCertificate(String timeCertificate) async {
    setState(() => isGenerating = true);

    try {
      final pdf = pw.Document();
      final font = await rootBundle.load("files/fonts/Parkinsans-VariableFont_wght.ttf");
      final ttf = pw.Font.ttf(font);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) {
            return pw.Container(
              decoration: const pw.BoxDecoration(
                gradient: pw.LinearGradient(colors: [PdfColors.indigoAccent, PdfColors.indigo, PdfColors.indigoAccent]),
              ),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    AppTheme.appName,
                    style: pw.TextStyle(font: ttf, fontSize: 35, color: PdfColors.white),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'CERTIFICATE OF COMPLETION',
                    style: pw.TextStyle(font: ttf, fontSize: 30, color: PdfColors.white),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'This is to certify that',
                    style: pw.TextStyle(font: ttf, fontSize: 20, color: PdfColors.white),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    UserData.googleUserName,
                    style: pw.TextStyle(font: ttf, fontSize: 25, color: PdfColors.white),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'has successfully completed the course',
                    style: pw.TextStyle(font: ttf, fontSize: 20, color: PdfColors.white),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "'${widget.cTitle}'",
                    style: pw.TextStyle(fontItalic: pw.Font.timesItalic(), font: ttf, fontSize: 25, color: PdfColors.white),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.Column(
                        children: [
                          pw.Text(
                            timeCertificate,
                            style: pw.TextStyle(font: ttf, fontSize: 12.0, color: PdfColors.white),
                          ),
                          pw.Container(width: 150, child: pw.Divider(color: PdfColors.white)),
                          pw.Text(
                            'Certificate Date',
                            style: pw.TextStyle(font: ttf, color: PdfColors.white),
                          ),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text(
                            'Tushar Mistry',
                            style: pw.TextStyle(font: ttf, fontSize: 12.0, color: PdfColors.white),
                          ),
                          pw.Container(width: 150, child: pw.Divider(color: PdfColors.white)),
                          pw.Text(
                            'Team ${AppTheme.appName}',
                            style: pw.TextStyle(font: ttf, color: PdfColors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4.0),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.SizedBox(width: 25),
                      pw.Text(
                        "Note: This Certificate is an Online Generated Document for Student E-Mail: '${UserData.googleUserEmail}'.\nDigital Signature Validation: Contact the Course Organiser for Authentication and Officially Validate this Document.",
                        style: pw.TextStyle(font: ttf, fontSize: 7.50, color: PdfColors.white),
                      ),
                      pw.SizedBox(width: 25),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
      String pdfName = "";
      pdfName += AppTheme.appName;
      pdfName += "_";
      pdfName += widget.cTitle.replaceAll(" ", "_");
      pdfName += "_Certification";

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$pdfName.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareFiles(
        [file.path],
        text:
            "Dear Sir/Ma'am,\n\nPlease find the Certificate from ${AppTheme.appName}- Course: ${widget.cTitle}.\n\nThank You,\nTushar Mistry,\nAdmin - ${AppTheme.appName}",
        subject: "${AppTheme.appName} - Certification - ${widget.cTitle}",
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> routeToYoutubePlayer(DocumentSnapshot E, int currentIndex) async {
    bool valueAutoPlay = false;
    int valueAutoSave = 5;
    wait() async {
      valueAutoPlay = await box.get('AutoPlay', defaultValue: false);
      valueAutoSave = await box.get('AutoSave', defaultValue: 5);
    }

    await wait().then(
      (value) => Navigator.of(context).push(
        PageAnimationTransition(
          pageAnimationType: RightToLeftTransition(),
          page: YoutubePlayerPage(
            autoSaving: valueAutoSave,
            previousPercentage: 100,
            courseTitle: E["Title"],
            lectureIndexInId: currentIndex,
            noOfLecture: E["Id"].length,
            startFrom: 0,
            idYoutube: E["Id"][currentIndex],
            autoPlayVideo: valueAutoPlay,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    box = Hive.box('ALL');
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
                padding: const EdgeInsets.fromLTRB(10.0, 75.0, 10.0, 0.0),
                child: StreamBuilder(
                  stream: FirebaseControls.readCompletedCourse(),
                  builder: (context, AsyncSnapshot snapshot) {
                    return (snapshot.hasData)
                        ? Builder(
                            builder: (context) {
                              DocumentSnapshot E;
                              int iter = 0;
                              while (iter < snapshot.data.docs.length) {
                                debugPrint(snapshot.data.docs[iter]["Title"]);
                                if (widget.cTitle == "${snapshot.data.docs[iter]["Title"]}") {
                                  break;
                                }
                                iter++;
                              }
                              E = snapshot.data.docs[iter];
                              return SingleChildScrollView(
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
                                                        TextSpan(
                                                          text: "\n\nYou have Completed this Course and  Eligible for the Certification.",
                                                          style: AppTheme.t6TitleSmall(
                                                            context,
                                                          )!.copyWith(fontWeight: FontWeight.w700, color: Colors.green.shade700),
                                                        ),
                                                        const TextSpan(text: "\n\nCompleted on:\n"),
                                                        TextSpan(
                                                          text: E["Date"].toString(),
                                                          style: AppTheme.t4TitleLarge(context)!.copyWith(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: -3.0 + AppTheme.t4TitleLarge(context)!.fontSize!,
                                                            color: Colors.green.shade700,
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
                                                      Card(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                "100 %",
                                                                style: AppTheme.t5TitleMedium(
                                                                  context,
                                                                )!.copyWith(fontWeight: FontWeight.w600, color: Colors.green.shade800),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      GestureDetector(
                                                        onTap: () => isGenerating
                                                            ? null
                                                            : generateCertificate(E['Date'].toString())
                                                                  .then(
                                                                    (value) => ShowSnackInfo.success(
                                                                      contentText: "Certificate Generated Successfully...",
                                                                    ).show(context),
                                                                    onError: (e) => ShowSnackInfo.success(
                                                                      contentText: "Something Went Wrong...\nPlease Try Again Later",
                                                                    ).show(context),
                                                                  )
                                                                  .then((value) => setState(() => isGenerating = false)),
                                                        child: Card(
                                                          color: Colors.white,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 7.5),
                                                                  child: Text(
                                                                    isGenerating ? "Please Wait..." : "Share Certificate",
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
                                                                  child: Icon(Icons.card_giftcard, color: AppTheme.onPrimary),
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
                                                    itemBuilder: (BuildContext context, iterationIndexForSections) {
                                                      return Padding(
                                                        padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                                                        child: Column(
                                                          children: [
                                                            (iterationIndexForSections == 0)
                                                                ? const SizedBox(height: 0.0, width: 00.0)
                                                                : Divider(thickness: 2.0, color: AppTheme.secondary),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(7.5, 0.0, 7.5, 0.0),
                                                              child: ListTile(
                                                                onTap: () async {
                                                                  if (!(iterationIndexForSections != 0 &&
                                                                      int.parse(E["Progress"][iterationIndexForSections - 1]) != 100)) {
                                                                    routeToYoutubePlayer(E, iterationIndexForSections);
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
                                                                          E["LT"][iterationIndexForSections].toString(),
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
                                                                          secToHHMMSS(int.parse(E["Length"][iterationIndexForSections])).toString(),
                                                                          textAlign: TextAlign.left,
                                                                          style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                                            fontWeight: FontWeight.w600,
                                                                            letterSpacing: 1.5,
                                                                            // fontSize: 22.50,
                                                                            color: AppTheme.primary,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Icon(Icons.done_all_outlined, color: Colors.green.shade800),
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
                builder: (context) => const AppbarCard(
                  adc: null,
                  titleAppBar: "Certifications",
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
