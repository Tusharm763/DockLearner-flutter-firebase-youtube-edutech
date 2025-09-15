import 'dart:core';
import 'package:dock_learner/app_info/terms_conditions_privacy.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:text_marquee/text_marquee.dart';

import '../auth_logic/profile_settings/extracted_widgets.dart';
import '../core/data_model/role_data_model.dart';
import '../core/theme_set/theme_colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppTheme.primary,
        systemNavigationBarColor: AppTheme.primary, //.withOpacity(0.5),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppTheme.primary,
        systemNavigationBarColor: AppTheme.primary, //.withOpacity(0.5),
      ),
    );
    super.dispose();
  }

  bool readMore = false;

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
                padding: const EdgeInsets.only(top: 65.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 1.0),
                    child: ListView(
                      children: [
                        const Padding(padding: EdgeInsets.all(5.0)),
                        Card(
                          color: AppTheme.primary,
                          child: Column(
                            children: [
                              const Padding(padding: EdgeInsets.all(5.0)),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AboutDialog(
                                          applicationName: AppTheme.appName,
                                          applicationVersion: "Version: 1.0.0",
                                          applicationLegalese: "A Flutter Application (Android and iOS) for Education Technology.\n\nBy Tushar Mistry",
                                          applicationIcon: Card(
                                            elevation: 5.0,
                                            child: SizedBox(
                                              child: Card(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                child: SizedBox(
                                                  height: 42.50,
                                                  width: 42.50,
                                                  child: Image.asset("files/images/app_logo.png", fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                                      child: Card(
                                        elevation: 5.0,
                                        child: SizedBox(
                                          child: Card(
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            child: SizedBox(
                                              height: 62.50,
                                              width: 62.50,
                                              child: Image.asset("files/images/app_logo.png", fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppTheme.appName,
                                          style: AppTheme.t4TitleLarge(
                                            context,
                                          )!.copyWith(color: AppTheme.onPrimary, letterSpacing: 5.0, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Version: ${AppTheme.currentVersion}",
                                          style: AppTheme.t6TitleSmall(
                                            context,
                                          )!.copyWith(color: AppTheme.onPrimary, letterSpacing: 2.5, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () => setState(() => readMore = !readMore),
                                  child: Card(
                                    color: AppTheme.pCon,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: RichText(
                                        // maxLines: readMore ? 5000 : 11,
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => setState(() => readMore = !readMore),
                                          children: [
                                            TextSpan(
                                              text:
                                              "The ${AppTheme
                                                  .appName} is an Ed-Tech Mobile Application, your go-to educational companion that transforms how you learn. This app combines cutting-edge technology with user-friendly design to create an engaging learning experience for students, teachers, and institutions alike.",
                                            ),
                                            TextSpan(
                                              text: (readMore)
                                                  ? "\n\nWhether you're studying mathematics, languages, or professional skills, ${AppTheme
                                                  .appName} provides interactive lessons, real-time progress tracking, and personalized learning paths all in one place.\n\nWith features like collaborative tools, and cross-platform compatibility, we're making quality education accessible to everyone, anywhere, anytime. Join our growing community and discover a smarter way to learn with ${AppTheme
                                                  .appName}.\n\nMade on\n    Flutter : ${FlutterVersion.version}\n    Dart : ${FlutterVersion
                                                  .dartVersion}\n"
                                                  : "",
                                            ),
                                            TextSpan(
                                              text: (readMore) ? "  ...Read Less." : "  ...Read More.",
                                              style: AppTheme.t5TitleMedium(
                                                context,
                                              )!.copyWith(color: AppTheme.primary, letterSpacing: 2.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                          style: AppTheme.t6TitleSmall(
                                            context,
                                          )!.copyWith(color: AppTheme.primary, letterSpacing: 1.0, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: AppTheme.primary,
                          elevation: 5.0,
                          clipBehavior: Clip.hardEdge,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: ExpansionTile(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              iconColor: AppTheme.onPrimary,
                              textColor: AppTheme.primary,
                              backgroundColor: AppTheme.primary,
                              tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                              initiallyExpanded: true,
                              maintainState: false,
                              title: Text(
                                "About Developers",
                                style: AppTheme.t5TitleMedium(
                                  context,
                                )!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onPrimary, letterSpacing: 1.4),
                              ),
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: SizedBox(height: 30.0, width: 30.0, child: Icon(Icons.developer_mode, size: 21.50, color: AppTheme.pCon)),
                              ),
                              trailing: Icon(
                                Icons.navigate_next,
                                size: 0, //27.5,
                                color: AppTheme.onPrimary,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                                  child: Card(
                                    color: AppTheme.pCon,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 12.50),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: AppTheme.primary, width: 2.0),
                                                ),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    "https://lh3.googleusercontent.com/a/ACg8ocJfvUcDgF8WGdXtSMPvK-U7Tw8GVvzkE70sU5gyxjiTg0LhJA=s96-c",
                                                    width: 40.0,
                                                    height: 40.0,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                      if (loadingProgress == null) {
                                                        return child;
                                                      }
                                                      return const Center(child: CircularProgressIndicator());
                                                    },
                                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                      return Center(child: Icon(Icons.person, size: 45.0, color: AppTheme.primary));
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Text(
                                                    "Tushar Mistry",
                                                    style: AppTheme.t4TitleLarge(context)!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      // fontSize: 25.0,
                                                      color: AppTheme.primary,
                                                      letterSpacing: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(thickness: 2.0, color: AppTheme.primary),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 0.0),
                                            child: ListTile(
                                              minLeadingWidth: 0.0,
                                              contentPadding: EdgeInsets.zero,
                                              title: RichText(
                                                text: TextSpan(
                                                  text:
                                                  "Flutter Mobile Application Development - Intermediate Level\nBackend Development - RESTFull API - Flask Python",
                                                  style: AppTheme.t6TitleSmall(
                                                    context,
                                                  )!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary, letterSpacing: 2.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: ListTile(
                                              minLeadingWidth: 0.0,
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(Icons.school, color: AppTheme.primary),
                                              title: RichText(
                                                textAlign: TextAlign.justify,
                                                text: TextSpan(
                                                  text: "UnderGraduate B.Tech'2026\nPre-Final Year",
                                                  style: AppTheme.t6TitleSmall(
                                                    context,
                                                  )!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary, letterSpacing: 2.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: ListTile(
                                              minLeadingWidth: 0.0,
                                              contentPadding: EdgeInsets.zero,
                                              leading: Icon(Icons.mail, color: AppTheme.primary),
                                              title: RichText(
                                                textAlign: TextAlign.justify,
                                                text: TextSpan(
                                                  text: "mistrytushar07@gmail.com",
                                                  style: AppTheme.t6TitleSmall(
                                                    context,
                                                  )!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary, letterSpacing: 2.0),
                                                ),
                                                maxLines: 3,
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
                        ),
                        const SizedBox(height: 10.0),
                        const TitleInSettings(textToDisplay: "Other Information"), // Regulations"),
                        const SizedBox(height: 2.50),
                        Card(
                          margin: const EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 6.0),
                          color: AppTheme.primary,
                          elevation: 5.0,
                          clipBehavior: Clip.hardEdge,
                          child: ExpansionTile(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            iconColor: AppTheme.onPrimary,
                            textColor: AppTheme.primary,
                            backgroundColor: AppTheme.primary,
                            tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                            title: TextMarquee(
                              "Data Management",
                              // "Delete Your Data in this App",
                              style: AppTheme.t5TitleMedium(context)!.copyWith(
                                fontWeight: FontWeight.bold,
                                // fontSize: 25.0,
                                color: AppTheme.onPrimary,
                                letterSpacing: 1.4,
                              ),
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(height: 30.0, width: 30.0, child: Image.asset("files/images/firebase_logo.png")),
                            ),
                            trailing: Icon(
                              Icons.navigate_next,
                              size: 0, //27.5,
                              color: AppTheme.onPrimary,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                                child: Card(
                                  color: AppTheme.pCon,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        text:
                                        "While using this ,${AppTheme
                                            .appName} Application, We focus on assuring that our User's Data ,i.e., the Student's, the Course Organiser's, is End-to-End Encrypted and Securely Stored at the Google FireBase - Cloud DataBase.\nFurtherMore, We acknowledge the Time-to-Time Data Management and Security regulations are being Followed up, to provide you the best of all Services.\nFirebase - DataBase Security.... ",
                                        style: AppTheme.t7LabelLarge(context)!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          // fontSize: 25.0,
                                          color: AppTheme.primary,
                                          letterSpacing: 1.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 6.0),
                          color: AppTheme.primary,
                          elevation: 5.0,
                          clipBehavior: Clip.hardEdge,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: ExpansionTile(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              iconColor: AppTheme.onPrimary,
                              textColor: AppTheme.primary,
                              backgroundColor: AppTheme.primary,
                              tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                              title: TextMarquee(
                                "Youtube Data",
                                style: AppTheme.t5TitleMedium(
                                  context,
                                )!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onPrimary, letterSpacing: 1.4),
                              ),
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: SizedBox(height: 30.0, width: 30.0, child: Image.asset("files/images/youtube_logo.png")),
                              ),
                              trailing: Icon(
                                Icons.navigate_next,
                                size: 0, //27.5,
                                color: AppTheme.onPrimary,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                                  child: Card(
                                    color: AppTheme.pCon,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          text:
                                          "${AppTheme
                                              .appName} is an EdTech Application, Hence has a Collaborative, authoritarian Interaction for a Youtube Videos as a part of Course Structure. With the help of Youtube's Developer Option, We have been able to Achieve these great Builds, and Interaction for Users, i.e., the Students, and the Course Organisers.\n\nThe Students are Interacted with the Youtube-Chrome (Share In App) in the Course Completion Screen.\nWhile the Course Organisers can Create the Course only by the support of Youtube Videos Live Data.",
                                          style: AppTheme.t7LabelLarge(context)!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 25.0,
                                            color: AppTheme.primary,
                                            letterSpacing: 1.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 6.0),
                          color: AppTheme.primary,
                          elevation: 5.0,
                          clipBehavior: Clip.hardEdge,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: GestureDetector(
                              child: ExpansionTile(
                                onExpansionChanged: (bool? val) {
                                  Navigator.of(
                                    context,
                                  ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const TCPrivacyPolicy()));
                                },
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                iconColor: AppTheme.onPrimary,
                                textColor: AppTheme.primary,
                                backgroundColor: AppTheme.primary,
                                tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                                title: TextMarquee(
                                  "T&C and Privacy Policy",
                                  // "Delete Your Data in this App",
                                  style: AppTheme.t5TitleMedium(
                                    context,
                                  )!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onPrimary, letterSpacing: 1.4),
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: SizedBox(height: 30.0, width: 30.0, child: Icon(Icons.policy, size: 21.50, color: AppTheme.pCon)),
                                ),
                                trailing: Icon(
                                  Icons.navigate_next,
                                  size: 0, //27.5,
                                  color: AppTheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 6.0),
                          color: AppTheme.primary,
                          elevation: 5.0,
                          clipBehavior: Clip.hardEdge,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: GestureDetector(
                              child: ExpansionTile(
                                onExpansionChanged: (bool? val) {
                                  Navigator.of(context).push(
                                    PageAnimationTransition(
                                      pageAnimationType: RightToLeftTransition(),
                                      page: LicensePage(
                                        applicationName: AppTheme.appName,
                                        applicationVersion: "Ver: 1.0.0",
                                        applicationLegalese:
                                        "A Flutter Based - Application (Android and iOS) for Education Technology, with enhanced and Dynamic User Interface for both the ${RoleToString
                                            .student} and ${RoleToString.courseOrganiser}.\n\nDeveloped By Tushar Mistry",
                                        applicationIcon: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Card(
                                            elevation: 5.0,
                                            child: Card(
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              child: SizedBox(
                                                height: 45.0,
                                                width: 45.0,
                                                child: Image.asset("files/images/app_logo.png", fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                iconColor: AppTheme.onPrimary,
                                textColor: AppTheme.primary,
                                backgroundColor: AppTheme.primary,
                                tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                                title: TextMarquee(
                                  "View Licenses",
                                  style: AppTheme.t5TitleMedium(context)!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 25.0,
                                    color: AppTheme.onPrimary,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: SizedBox(height: 30.0, width: 30.0, child: Icon(Icons.list_alt, size: 21.50, color: AppTheme.pCon)),
                                ),
                                trailing: Icon(
                                  Icons.navigate_next,
                                  size: 0, //27.5,
                                  color: AppTheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.fromLTRB(5.0, 6.0, 5.0, 6.0)),
                      ],
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) =>
                const AppbarCard(
                  adc: null,
                  titleAppBar: "About Us",
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
