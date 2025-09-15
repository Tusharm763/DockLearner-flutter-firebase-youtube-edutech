import 'package:dock_learner/auth_logic/profile_settings/extracted_widgets_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../app_info/terms_conditions_privacy.dart';
import '../../core/data_model/role_data_model.dart';
import '../../course_logic_role/viewer_logic/listview_layouts/completed_courses.dart';
import 'extracted_widgets.dart';
import '../../core/theme_set/snack_theme.dart';
import '../../core/theme_set/theme_colors.dart';
import '../../core/data_model/user_data_model.dart';

class AppProfileSettings extends StatefulWidget {
  const AppProfileSettings({super.key});

  @override
  State<AppProfileSettings> createState() => _AppProfileSettingsState();
}

class _AppProfileSettingsState extends State<AppProfileSettings> {
  late final Box box;

  @override
  void initState() {
    box = Hive.box('ALL');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: AppTheme.primary, systemNavigationBarColor: AppTheme.primary));
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
                        const TitleInSettings(textToDisplay: "Account Details"),
                        Card(
                          color: AppTheme.primary,
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
                                        border: Border.all(color: AppTheme.onPrimary, width: 2.0),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          UserData.googleUserPhotoURL,
                                          // userGoogleAcc.photoURL ?? "Error_Loading_Photo",
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const Center(child: CircularProgressIndicator());
                                          },
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Center(child: Icon(Icons.person, size: 45.0, color: AppTheme.onPrimary));
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            UserData.googleUserName,
                                            // userGoogleAcc.displayName.toString(),
                                            maxLines: 1,
                                            style: AppTheme.t4TitleLarge(context)!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              // fontSize: 25.0,
                                              color: AppTheme.onPrimary,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: ListTile(
                                    dense: true,
                                    // isThreeLine: true,
                                    title: Text(
                                      (UserData.googleUserIsVerified) ? "E-Mail : Verified" : "E-Mail : Not Verified",
                                      // (userGoogleAcc.emailVerified) ? "E-Mail : Verified " : "E-Mail : Not Verified",
                                      style: AppTheme.t5TitleMedium(context)!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        // fontSize: 25.0,
                                        color: AppTheme.onPrimary,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    subtitle: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        UserData.googleUserEmail,
                                        // userGoogleAcc.email.toString(),
                                        maxLines: 1,
                                        style: AppTheme.t6TitleSmall(context)!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          // fontSize: 25.0,
                                          color: AppTheme.onPrimary,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: box.listenable(keys: ['Role']),
                          builder: (context, box, child) {
                            String roleHiveWatch = RoleToString.student; //"Student";
                            roleHiveWatch = box.get('Role').toString();
                            return Card(
                              color: AppTheme.primary,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 12.50, 15.0, 10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: ListTile(
                                        title: Text(
                                          "Signed in as:  ",
                                          style: AppTheme.t5TitleMedium(context)!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 25.0,
                                            color: AppTheme.onPrimary,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        subtitle: Text(
                                          (roleHiveWatch == RoleToString.student) ? RoleToString.student : RoleToString.courseOrganiser,
                                          style: AppTheme.t4TitleLarge(context)!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 25.0,
                                            color: AppTheme.onPrimary,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10.0),
                        const TitleInSettings(textToDisplay: "Personal Settings"),
                        // (myCoursesHive.isNotEmpty && false)
                        //     ? GestureDetector(
                        //         onTap: () async {
                        //           var hivDb = await Hive.openBox("ALL");
                        //           List<dynamic> hivDownloads = hivDb.get("mycourse") ?? List.empty(growable: true);
                        //           // Navigator.push(
                        //           //   context,
                        //           //   MaterialPageRoute(
                        //           //     builder: (BuildContext context) =>
                        //           Navigator.of(context).push(
                        //             PageAnimationTransition(
                        //               pageAnimationType: RightToLeftTransition(),
                        //               page: OffViewAllCourse(
                        //                 allDownloadedCourses: hivDownloads,
                        //               ),
                        //             ),
                        //           );
                        //
                        //           // Navigator.push(
                        //           //   context,
                        //           //   MaterialPageRoute(
                        //           //     builder: (BuildContext context) => const AccSettings(),
                        //           //   ),
                        //           // );
                        //         },
                        //         child: Card(
                        //           color: AppTheme.primary,
                        //           child: Padding(
                        //             padding: const EdgeInsets.fromLTRB(7.50, 10.0, 7.50, 10.0),
                        //             child: ListTile(
                        //               title: Text(
                        //                 "Downloads",
                        //                 // "Delete Your Data in this App",
                        //                 style: AppTheme.t5TitleMedium(context)!.copyWith(
                        //                   fontWeight: FontWeight.bold,
                        //                   // fontSize: 25.0,
                        //                   color: AppTheme.onPrimary,
                        //                   letterSpacing: 1.4,
                        //                 ),
                        //               ),
                        //               leading: Icon(
                        //                 Icons.download_done,
                        //                 size: 27.5, //AppTheme.t3HeadlineSmall(context)!.fontSize,
                        //                 color: AppTheme.onPrimary,
                        //               ),
                        //               // trailing: Icon(
                        //               //   Icons.navigate_next,
                        //               //   size: 27.5,
                        //               //   color: AppTheme.onPrimary,
                        //               // ),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : const SizedBox(
                        //         height: 0.0,
                        //       ),
                        GestureDetector(
                          onTap: () => Navigator.of(
                            context,
                          ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const ViewAllCompletedCourses())),
                          child: Card(
                            color: AppTheme.primary,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(7.50, 10.0, 7.50, 10.0),
                              child: ListTile(
                                title: Text(
                                  "Completed Courses",
                                  // "Delete Your Data in this App",
                                  style: AppTheme.t5TitleMedium(context)!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 25.0,
                                    color: AppTheme.onPrimary,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.checklist_rtl,
                                  size: 27.5, //AppTheme.t3HeadlineSmall(context)!.fontSize,
                                  color: AppTheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          // onDoubleTap: () => Navigator.push(
                          //   context,
                          //   PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const PlayVideoFromStorage()),
                          // ),
                          onTap: () =>
                              // true
                              //     ? Navigator.push(context, PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const MyApp()))
                              //     :
                              ShowSnackInfo.error(contentText: "Not Available for Now...").show(context),
                          // onTap: () => Navigator.of(
                          //   context,
                          // ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const ViewAllCompletedCourses())),
                          child: Card(
                            color: AppTheme.primary,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(7.50, 10.0, 7.50, 10.0),
                              child: ListTile(
                                title: Text(
                                  "Offline Access | Courses",
                                  // "Delete Your Data in this App",
                                  style: AppTheme.t5TitleMedium(context)!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 25.0,
                                    color: AppTheme.onPrimary,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.download_for_offline_outlined,
                                  size: 27.5, //AppTheme.t3HeadlineSmall(context)!.fontSize,
                                  color: AppTheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // // TODO: ValueListenableBuilder for AutoSave AutoPlay
                        // ValueListenableBuilder(
                        //   valueListenable: box.listenable(keys: ['AutoPlay']),
                        //   builder: (context, box, child) {
                        //     bool boolAutoPlay = false;
                        //     boolAutoPlay = bool.parse(box.get('AutoPlay', defaultValue: 'false').toString());
                        //     return GestureDetector(
                        //       onTap: () => showDialog(
                        //         context: context,
                        //         builder: (context) {
                        //           return (boolAutoPlay)
                        //               ? AlertDialog(
                        //                   backgroundColor: AppTheme.secondary,
                        //                   title: Column(
                        //                     children: [
                        //                       Align(
                        //                         alignment: Alignment.centerLeft,
                        //                         child: Text(
                        //                           "Turn-Off AutoPlay Video?",
                        //                           style: AppTheme.t6TitleSmall(context)?.copyWith(
                        //                             letterSpacing: 1,
                        //                             fontWeight: FontWeight.w600,
                        //                             color: AppTheme.onPrimary,
                        //                             // color: Colors.deepPurple,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       Divider(
                        //                         thickness: 2.75,
                        //                         color: AppTheme.onSecondary,
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   content: RichText(
                        //                     textAlign: TextAlign.justify,
                        //                     text: TextSpan(
                        //                       recognizer: TapGestureRecognizer()
                        //                         ..onTap = () {
                        //                           Navigator.of(context).push(
                        //                             PageAnimationTransition(
                        //                               pageAnimationType: RightToLeftTransition(),
                        //                               page: const TCPrivacyPolicy(),
                        //                             ),
                        //                           );
                        //                         },
                        //                       text:
                        //                           "AutoPlay Feature helps you to Auto Start the Youtube Video as soon as you Go to Section Screen. Do you want to Turn it OFF?",
                        //                       style: AppTheme.t8LabelMedium(context)?.copyWith(
                        //                         letterSpacing: 1,
                        //                         fontWeight: FontWeight.w600,
                        //                         color: AppTheme.onSecondary,
                        //                         // color: Colors.deepPurple,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   actions: [
                        //                     Row(
                        //                       mainAxisAlignment: MainAxisAlignment.end,
                        //                       children: [
                        //                         ElevatedButton(
                        //                           onPressed: () async {
                        //                             await box
                        //                                 .put('AutoPlay', false)
                        //                                 .then(
                        //                                   (value) => ShowSnackInfo.success(
                        //                                     contentText:
                        //                                         "AutoPlay Turned ${("true" == box.get('AutoPlay', defaultValue: false).toString().toLowerCase().toString().toLowerCase()) ? "ON" : "OFF"}.",
                        //                                   ).show(context),
                        //                                 )
                        //                                 .then((value) => Navigator.pop(context));
                        //                             debugPrint(box.get('AutoPlay', defaultValue: "false").toString());
                        //                           },
                        //                           clipBehavior: Clip.antiAlias,
                        //                           child: Text(
                        //                             "Turn Off",
                        //                             // Sign-In "",
                        //                             style: AppTheme.t7LabelLarge(context)?.copyWith(
                        //                               letterSpacing: 1,
                        //                               fontWeight: FontWeight.bold,
                        //                               color: AppTheme.error,
                        //                               // color: Colors.deepPurple,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 )
                        //               : AlertDialog(
                        //                   backgroundColor: AppTheme.secondary,
                        //                   title: Column(
                        //                     children: [
                        //                       Align(
                        //                         alignment: Alignment.centerLeft,
                        //                         child: Text(
                        //                           "AutoPlay Video?",
                        //                           style: AppTheme.t6TitleSmall(context)?.copyWith(
                        //                             letterSpacing: 1,
                        //                             fontWeight: FontWeight.w600,
                        //                             color: AppTheme.onPrimary,
                        //                             // color: Colors.deepPurple,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       Divider(
                        //                         thickness: 2.75,
                        //                         color: AppTheme.onSecondary,
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   content: RichText(
                        //                     textAlign: TextAlign.justify,
                        //                     text: TextSpan(
                        //                       recognizer: TapGestureRecognizer()
                        //                         ..onTap = () {
                        //                           Navigator.of(context).push(
                        //                             PageAnimationTransition(
                        //                               pageAnimationType: RightToLeftTransition(),
                        //                               page: const TCPrivacyPolicy(),
                        //                             ),
                        //                           );
                        //                         },
                        //                       text:
                        //                           "AutoPlay Feature helps you to Auto Start the Youtube Video as soon as you Go to Section Screen. Do you want to Turn it ON?",
                        //                       style: AppTheme.t8LabelMedium(context)?.copyWith(
                        //                         letterSpacing: 1,
                        //                         fontWeight: FontWeight.w600,
                        //                         color: AppTheme.onSecondary,
                        //                         // color: Colors.deepPurple,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   actions: [
                        //                     Row(
                        //                       mainAxisAlignment: MainAxisAlignment.end,
                        //                       children: [
                        //                         ElevatedButton(
                        //                           onPressed: () async {
                        //                             await box
                        //                                 .put('AutoPlay', true)
                        //                                 .then(
                        //                                   (value) => ShowSnackInfo.success(
                        //                                     contentText:
                        //                                         "AutoPlay Turned ${("true" == box.get('AutoPlay', defaultValue: false).toString().toLowerCase()) ? "ON" : "OFF"}.",
                        //                                   ).show(context),
                        //                                 )
                        //                                 .then((value) => Navigator.pop(context));
                        //                             debugPrint(box.get('AutoPlay', defaultValue: "false").toString());
                        //                             // Navigator.pop(context);
                        //                           },
                        //                           clipBehavior: Clip.antiAlias,
                        //                           child: Text(
                        //                             "Yes, Turn On",
                        //                             // Sign-In "",
                        //                             style: AppTheme.t7LabelLarge(context)?.copyWith(
                        //                               letterSpacing: 1,
                        //                               fontWeight: FontWeight.bold,
                        //                               color: AppTheme.error,
                        //                               // color: Colors.deepPurple,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 );
                        //         },
                        //       ),
                        //       child: Card(
                        //         color: AppTheme.primary,
                        //         child: Padding(
                        //           padding: const EdgeInsets.fromLTRB(7.50, 10.0, 7.50, 10.0),
                        //           child: ListTile(
                        //             title: Text(
                        //               "AutoPlay",
                        //               style: AppTheme.t5TitleMedium(context)!.copyWith(
                        //                 fontWeight: FontWeight.bold,
                        //                 // fontSize: 25.0,
                        //                 color: AppTheme.onPrimary,
                        //                 letterSpacing: 1.4,
                        //               ),
                        //             ),
                        //             leading: Icon(
                        //               Icons.auto_mode,
                        //               size: 27.5, //AppTheme.t3HeadlineSmall(context)!.fontSize,
                        //               color: AppTheme.onPrimary,
                        //             ),
                        //             trailing: Switch(
                        //               activeColor: AppTheme.pCon,
                        //               value: boolAutoPlay,
                        //               onChanged: (bool value) async {
                        //                 await showDialog(
                        //                   context: context,
                        //                   builder: (context) {
                        //                     //TODO:AutoPlay is ON
                        //                     return (boolAutoPlay)
                        //                         ? AlertDialog(
                        //                             backgroundColor: AppTheme.secondary,
                        //                             title: Column(
                        //                               children: [
                        //                                 Align(
                        //                                   alignment: Alignment.centerLeft,
                        //                                   child: Text(
                        //                                     "Turn-Off AutoPlay Video?",
                        //                                     style: AppTheme.t6TitleSmall(context)?.copyWith(
                        //                                       letterSpacing: 1,
                        //                                       fontWeight: FontWeight.w600,
                        //                                       color: AppTheme.onPrimary,
                        //                                       // color: Colors.deepPurple,
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                                 Divider(
                        //                                   thickness: 2.75,
                        //                                   color: AppTheme.onSecondary,
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                             content: RichText(
                        //                               textAlign: TextAlign.justify,
                        //                               text: TextSpan(
                        //                                 recognizer: TapGestureRecognizer()
                        //                                   ..onTap = () {
                        //                                     Navigator.of(context).push(
                        //                                       PageAnimationTransition(
                        //                                         pageAnimationType: RightToLeftTransition(),
                        //                                         page: const TCPrivacyPolicy(),
                        //                                       ),
                        //                                     );
                        //                                   },
                        //                                 text:
                        //                                     "AutoPlay Feature helps you to Auto Start the Youtube Video as soon as you Go to Section Screen. Do you want to Turn it OFF?",
                        //                                 style: AppTheme.t8LabelMedium(context)?.copyWith(
                        //                                   letterSpacing: 1,
                        //                                   fontWeight: FontWeight.w600,
                        //                                   color: AppTheme.onSecondary,
                        //                                   // color: Colors.deepPurple,
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                             actions: [
                        //                               Row(
                        //                                 mainAxisAlignment: MainAxisAlignment.end,
                        //                                 children: [
                        //                                   ElevatedButton(
                        //                                     onPressed: () async {
                        //                                       await box
                        //                                           .put('AutoPlay', false)
                        //                                           .then(
                        //                                             (value) => ShowSnackInfo.success(
                        //                                               contentText:
                        //                                                   "AutoPlay Turned ${("true" == box.get('AutoPlay', defaultValue: false).toString().toLowerCase()) ? "ON" : "OFF"}.",
                        //                                             ).show(context),
                        //                                           )
                        //                                           .then(
                        //                                             (value) => Navigator.pop(context),
                        //                                           );
                        //                                       debugPrint(
                        //                                           box.get('AutoPlay', defaultValue: "false").toString());
                        //                                       // Navigator.pop(context);
                        //                                     },
                        //                                     clipBehavior: Clip.antiAlias,
                        //                                     child: Text(
                        //                                       "Turn Off",
                        //                                       // Sign-In "",
                        //                                       style: AppTheme.t7LabelLarge(context)?.copyWith(
                        //                                         letterSpacing: 1,
                        //                                         fontWeight: FontWeight.bold,
                        //                                         color: AppTheme.error,
                        //                                         // color: Colors.deepPurple,
                        //                                       ),
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             ],
                        //                           )
                        //                         : AlertDialog(
                        //                             backgroundColor: AppTheme.secondary,
                        //                             title: Column(
                        //                               children: [
                        //                                 Align(
                        //                                   alignment: Alignment.centerLeft,
                        //                                   child: Text(
                        //                                     "AutoPlay Video?",
                        //                                     style: AppTheme.t6TitleSmall(context)?.copyWith(
                        //                                       letterSpacing: 1,
                        //                                       fontWeight: FontWeight.w600,
                        //                                       color: AppTheme.onPrimary,
                        //                                       // color: Colors.deepPurple,
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                                 Divider(
                        //                                   thickness: 2.75,
                        //                                   color: AppTheme.onSecondary,
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                             content: RichText(
                        //                               textAlign: TextAlign.justify,
                        //                               text: TextSpan(
                        //                                 recognizer: TapGestureRecognizer()
                        //                                   ..onTap = () {
                        //                                     Navigator.of(context).push(
                        //                                       PageAnimationTransition(
                        //                                         pageAnimationType: RightToLeftTransition(),
                        //                                         page: const TCPrivacyPolicy(),
                        //                                       ),
                        //                                     );
                        //                                   },
                        //                                 text:
                        //                                     "AutoPlay Feature helps you to Auto Start the Youtube Video as soon as you Go to Section Screen. Do you want to Turn it ON?",
                        //                                 style: AppTheme.t8LabelMedium(context)?.copyWith(
                        //                                   letterSpacing: 1,
                        //                                   fontWeight: FontWeight.w600,
                        //                                   color: AppTheme.onSecondary,
                        //                                   // color: Colors.deepPurple,
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                             actions: [
                        //                               Row(
                        //                                 mainAxisAlignment: MainAxisAlignment.end,
                        //                                 children: [
                        //                                   ElevatedButton(
                        //                                     onPressed: () async {
                        //                                       await box
                        //                                           .put('AutoPlay', true)
                        //                                           .then(
                        //                                             (value) => ShowSnackInfo.success(
                        //                                               contentText:
                        //                                                   "AutoPlay Turned ${("true" == box.get('AutoPlay', defaultValue: false).toString().toLowerCase()) ? "ON" : "OFF"}.",
                        //                                             ).show(context),
                        //                                           )
                        //                                           .then((value) => Navigator.pop(context));
                        //                                       debugPrint(
                        //                                           box.get('AutoPlay', defaultValue: "false").toString());
                        //                                       // Navigator.pop(context);
                        //                                     },
                        //                                     clipBehavior: Clip.antiAlias,
                        //                                     child: Text(
                        //                                       "Yes, Turn On",
                        //                                       // Sign-In "",
                        //                                       style: AppTheme.t7LabelLarge(context)?.copyWith(
                        //                                         letterSpacing: 1,
                        //                                         fontWeight: FontWeight.bold,
                        //                                         color: AppTheme.error,
                        //                                         // color: Colors.deepPurple,
                        //                                       ),
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             ],
                        //                           );
                        //                   },
                        //                 );
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                        //
                        // ValueListenableBuilder(
                        //     valueListenable: box.listenable(keys: ['AutoSave']),
                        //     builder: (context, box, child) {
                        //       int autoSavingValue = 5;
                        //       autoSavingValue = box.get('AutoSave', defaultValue: 5);
                        //       return GestureDetector(
                        //         onTap: () => showDialog(
                        //           context: context,
                        //           builder: (context) {
                        //             //TODO:AutoPlay is ON
                        //             return AlertDialog(
                        //               backgroundColor: AppTheme.secondary,
                        //               title: Column(
                        //                 children: [
                        //                   Align(
                        //                     alignment: Alignment.centerLeft,
                        //                     child: Text(
                        //                       "AutoSaving Percentage...",
                        //                       style: AppTheme.t6TitleSmall(context)?.copyWith(
                        //                         letterSpacing: 1,
                        //                         fontWeight: FontWeight.w600,
                        //                         color: AppTheme.onPrimary,
                        //                         // color: Colors.deepPurple,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   Divider(
                        //                     thickness: 2.75,
                        //                     color: AppTheme.onSecondary,
                        //                   ),
                        //                 ],
                        //               ),
                        //               content: RichText(
                        //                 textAlign: TextAlign.justify,
                        //                 text: TextSpan(
                        //                   recognizer: TapGestureRecognizer()
                        //                     ..onTap = () {
                        //                       Navigator.of(context).push(
                        //                         PageAnimationTransition(
                        //                           pageAnimationType: RightToLeftTransition(),
                        //                           page: const TCPrivacyPolicy(),
                        //                         ),
                        //                       );
                        //                     },
                        //                   text:
                        //                       "AutoSaving Feature is Saving the Progress after every 'n' Percentage of that Video Lecture. \nLearn More in Terms and Conditions.\n\nDo you want to Change?",
                        //                   style: AppTheme.t8LabelMedium(context)?.copyWith(
                        //                     letterSpacing: 1,
                        //                     fontWeight: FontWeight.w600,
                        //                     color: AppTheme.onSecondary,
                        //                     // color: Colors.deepPurple,
                        //                   ),
                        //                 ),
                        //               ),
                        //               actions: [
                        //                 Row(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     TextButton(
                        //                       onPressed: () => Navigator.pop(context),
                        //                       clipBehavior: Clip.antiAlias,
                        //                       child: Text(
                        //                         "Cancel",
                        //                         // Sign-In "",
                        //                         style: AppTheme.t7LabelLarge(context)?.copyWith(
                        //                           letterSpacing: 1,
                        //                           fontWeight: FontWeight.bold,
                        //                           color: AppTheme.error,
                        //                           // color: Colors.deepPurple,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                     Column(
                        //                       crossAxisAlignment: CrossAxisAlignment.end,
                        //                       mainAxisAlignment: MainAxisAlignment.end,
                        //                       children: [
                        //                         (autoSavingValue != 3)
                        //                             ? ElevatedButton(
                        //                                 onPressed: () async {
                        //                                   await box
                        //                                       .put('AutoSave', 3)
                        //                                       .then((value) => ShowSnackInfo.success(
                        //                                             contentText:
                        //                                                 "AutoSave Changed: ${box.get('AutoSave')} %",
                        //                                           ).show(context))
                        //                                       .then((value) => Navigator.pop(context));
                        //                                   debugPrint(box.get('AutoSave', defaultValue: 3).toString());
                        //                                 },
                        //                                 clipBehavior: Clip.antiAlias,
                        //                                 child: Text(
                        //                                   "3 %",
                        //                                   // Sign-In "",
                        //                                   style: AppTheme.t8LabelMedium(context)?.copyWith(
                        //                                     letterSpacing: 1,
                        //                                     fontWeight: FontWeight.bold,
                        //                                     color: AppTheme.secondary,
                        //                                   ),
                        //                                 ),
                        //                               )
                        //                             : const SizedBox.shrink(),
                        //                         (autoSavingValue != 5)
                        //                             ? ElevatedButton(
                        //                                 onPressed: () async {
                        //                                   await box
                        //                                       .put('AutoSave', 5)
                        //                                       .then((value) => ShowSnackInfo.success(
                        //                                             contentText:
                        //                                                 "AutoSave Changed: ${box.get('AutoSave')} %",
                        //                                           ).show(context))
                        //                                       .then((value) => Navigator.pop(context));
                        //                                   debugPrint(box.get('AutoSave', defaultValue: 5).toString());
                        //                                   // Navigator.pop(context);
                        //                                 },
                        //                                 clipBehavior: Clip.antiAlias,
                        //                                 child: Text(
                        //                                   "5 %",
                        //                                   // Sign-In "",
                        //                                   style: AppTheme.t8LabelMedium(context)?.copyWith(
                        //                                     letterSpacing: 1,
                        //                                     fontWeight: FontWeight.bold,
                        //                                     color: AppTheme.secondary,
                        //                                     // color: Colors.deepPurple,
                        //                                   ),
                        //                                 ),
                        //                               )
                        //                             : const SizedBox.shrink(),
                        //                         (autoSavingValue != 10)
                        //                             ? ElevatedButton(
                        //                                 onPressed: () async {
                        //                                   await box
                        //                                       .put('AutoSave', 10)
                        //                                       .then((value) => ShowSnackInfo.success(
                        //                                             contentText:
                        //                                                 "AutoSave Changed: ${box.get('AutoSave')} %",
                        //                                           ).show(context))
                        //                                       .then((value) => Navigator.pop(context));
                        //                                   debugPrint(box.get('AutoSave', defaultValue: 10).toString());
                        //                                   // Navigator.pop(context);
                        //                                 },
                        //                                 clipBehavior: Clip.antiAlias,
                        //                                 child: Text(
                        //                                   "10 %",
                        //                                   // Sign-In "",
                        //                                   style: AppTheme.t8LabelMedium(context)?.copyWith(
                        //                                     letterSpacing: 1,
                        //                                     fontWeight: FontWeight.bold,
                        //                                     color: AppTheme.secondary,
                        //                                     // color: Colors.deepPurple,
                        //                                   ),
                        //                                 ),
                        //                               )
                        //                             : const SizedBox.shrink(),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             );
                        //           },
                        //         ),
                        //         child: Card(
                        //           color: AppTheme.primary,
                        //           child: Padding(
                        //             padding: const EdgeInsets.fromLTRB(7.50, 10.0, 7.50, 10.0),
                        //             child: ListTile(
                        //               title: Text(
                        //                 "AutoSave",
                        //                 // "Delete Your Data in this App",
                        //                 style: AppTheme.t5TitleMedium(context)!.copyWith(
                        //                   fontWeight: FontWeight.bold,
                        //                   // fontSize: 25.0,
                        //                   color: AppTheme.onPrimary,
                        //                   letterSpacing: 1.4,
                        //                 ),
                        //               ),
                        //               leading: Icon(
                        //                 Icons.autorenew,
                        //                 size: 27.5, //AppTheme.t3HeadlineSmall(context)!.fontSize,
                        //                 color: AppTheme.onPrimary,
                        //               ),
                        //               trailing: Text(
                        //                 "$autoSavingValue %",
                        //                 // "Delete Your Data in this App",
                        //                 style: AppTheme.t4TitleLarge(context)!.copyWith(
                        //                   fontWeight: FontWeight.bold,
                        //                   // fontSize: 25.0,
                        //                   color: AppTheme.onPrimary,
                        //                   letterSpacing: 1.4,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     }),
                        const SizedBox(height: 10.0),
                        const TitleInSettings(textToDisplay: "Account Actions"),
                        ValueListenableBuilder(
                          valueListenable: box.listenable(keys: ['Role']),
                          builder: (context, box, child) {
                            String roleHiveWatch = RoleToString.student; //"Student";
                            roleHiveWatch = box.get('Role').toString();
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    //TODO:AutoPlay is ON
                                    return (roleHiveWatch == RoleToString.student) // "Student")
                                        ? AlertDialog(
                                            backgroundColor: AppTheme.secondary,
                                            title: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "${RoleToString.courseOrganiser}?",
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
                                                    "Switch to '${RoleToString.courseOrganiser}' role for Creating, Organising Courses and many other things.\nEnable this Feature for Creating and Organising your Course? ",
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
                                                      await box.put('Role', RoleToString.courseOrganiser).then((value) => Navigator.pop(context));
                                                      debugPrint(box.get('Role').toString());
                                                      // Navigator.pop(context);
                                                    },
                                                    clipBehavior: Clip.antiAlias,
                                                    child: Text(
                                                      "Yes",
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
                                          )
                                        : AlertDialog(
                                            backgroundColor: AppTheme.secondary,
                                            title: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "${RoleToString.student} Role?",
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
                                                    "Switch to '${RoleToString.student}' role for Enrolling, Completing a Course and many other things.\nSwitch to this Role for Enrolling and Completing your Pending Course?",
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
                                                      await box.put('Role', RoleToString.student).then((value) => Navigator.pop(context));
                                                      debugPrint(box.get('Role').toString());
                                                      // Navigator.pop(context);
                                                    },
                                                    clipBehavior: Clip.antiAlias,
                                                    child: Text(
                                                      "Change",
                                                      style: AppTheme.t7LabelLarge(
                                                        context,
                                                      )?.copyWith(letterSpacing: 1, fontWeight: FontWeight.bold, color: AppTheme.error),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                  },
                                ).then((value) {
                                  if (box.get('Role').toString() != roleHiveWatch) {
                                    ShowSnackInfo.success(contentText: "Role Changed: ${box.get('Role')}").show(context);
                                  }
                                });
                              },
                              child: Card(
                                color: AppTheme.primary,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(7.50, 10.0, 7.50, 10.0),
                                  child: ListTile(
                                    title: Text(
                                      "${(roleHiveWatch == RoleToString.student) ? RoleToString.courseOrganiser : RoleToString.student}?",
                                      // "Delete Your Data in this App",
                                      style: AppTheme.t5TitleMedium(context)!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        // fontSize: 25.0,
                                        color: AppTheme.onPrimary,
                                        letterSpacing: 1.4,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: Icon(Icons.change_circle_outlined, size: 27.5, color: AppTheme.onPrimary),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () async {
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
                                          "Are you sure, Log-Out?",
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
                                        ..onTap = () => Navigator.of(
                                          context,
                                        ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const TCPrivacyPolicy())),
                                      text:
                                          "Logging-out your Google Account, will lead to disconnecting from this Device. This will not delete or modify anything from your Courses. However, This will delete the Data stored intended inside this App.",
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(
                                            "No",
                                            style: AppTheme.t7LabelLarge(context)?.copyWith(
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.onSecondary,
                                              // color: Colors.deepPurple,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            v() async {
                                              await GoogleSignIn().signOut();
                                              await FirebaseAuth.instance.signOut();
                                              await UserData.reSetUserData();
                                            }

                                            await v().then((value) {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                            // Navigator.pop(context);
                                            // Navigator.pop(context);
                                          },
                                          clipBehavior: Clip.antiAlias,
                                          child: Text(
                                            "Log-Out",
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
                            );
                          },
                          child: Card(
                            color: AppTheme.primary,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(7.50, 10.0, 7.50, 10.0),
                              child: ListTile(
                                title: Text(
                                  "Log-out from this Device",
                                  // "Delete Your Data in this App",
                                  style: AppTheme.t5TitleMedium(context)!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 25.0,
                                    color: AppTheme.onPrimary,
                                    letterSpacing: 1.4,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: Icon(
                                  Icons.logout,
                                  size: 27.5, //AppTheme.t3HeadlineSmall(context)!.fontSize,
                                  color: AppTheme.onPrimary,
                                ),
                                trailing: Icon(Icons.navigate_next, size: 27.5, color: AppTheme.onPrimary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) => const AppbarCard(
                  adc: null,
                  titleAppBar: "Settings",
                  menu: SizedBox(height: 0.0, width: 0.0),
                  menuChildren: SizedBox(height: 0, width: 0),
                  showBackButton: true,
                  showMoreOption: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
