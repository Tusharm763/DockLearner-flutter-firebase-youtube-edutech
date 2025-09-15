import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dock_learner/auth_logic/firebase_controls.dart';
import 'package:dock_learner/auth_logic/profile_settings/profile_settings.dart';
import 'package:dock_learner/core/data_model/user_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:text_marquee/text_marquee.dart';
import '../app_info/terms_conditions_privacy.dart';
import '../core/data_model/role_data_model.dart';
import '../core/theme_set/snack_theme.dart';
import '../core/theme_set/theme_colors.dart';
import '../course_logic_role/action_logic/home_page_layout.dart';
import '../course_logic_role/viewer_logic/home_page_layout.dart';
import '../main.dart';
import 'drawer/drawer_home_layout.dart';

class HomeScreenUserLoggedIn extends StatefulWidget {
  const HomeScreenUserLoggedIn({super.key});

  @override
  State<HomeScreenUserLoggedIn> createState() => _HomeScreenUserLoggedInState();
}

class _HomeScreenUserLoggedInState extends State<HomeScreenUserLoggedIn> {
  late final Box box;

  final AdvancedDrawerController _adc = AdvancedDrawerController();
  Stream? loadCourseForStudent;
  Stream? allCourseRead;
  Stream? loadCourse;

  @override
  void initState() {
    box = Hive.box('ALL');
    super.initState();
    setState(() {});
  }

  Future<void> getAuthAndRouteToHome() async {
    if (FirebaseAuth.instance.currentUser?.uid.isNotEmpty != true) {
      final GoogleSignInAccount? googleUserAccount = await GoogleSignIn().signIn();
      if (googleUserAccount != null) {
        // final GoogleSignInAuthentication? googleAuthenticate = await googleUserAccount.authentication;
        final dynamic googleAuthenticate = await googleUserAccount.authentication;
        if (googleAuthenticate?.accessToken != null && googleAuthenticate?.idToken != null) {
          final credentials = GoogleAuthProvider.credential(accessToken: googleAuthenticate?.accessToken, idToken: googleAuthenticate?.idToken);
          await FirebaseAuth.instance
              .signInWithCredential(credentials)
              .then(
                (value) => ShowSnackInfo.success(contentText: "Signed-In as ${FirebaseAuth.instance.currentUser!.email}").show(context),
                onError: (e) async => await GoogleSignIn().signOut().then((value) {
                  if (e.toString().contains("administrator")) {
                    ShowSnackInfo.error(
                      contentText: "Something went wrong...\n${e.toString().substring(e.toString().indexOf(" ") + 1)}",
                    ).show(context);
                  }
                }),
              );
        }
      }
      setState(() {
        userGoogleAcc = FirebaseAuth.instance.currentUser;
        UserData.setUserData(FirebaseAuth.instance.currentUser!);
        debugPrint(UserData.googleUserEmail);
        debugPrint(UserData.googleUserName);
        debugPrint(UserData.googleUserUID);
        debugPrint(UserData.googleUserPhotoURL);
        debugPrint(UserData.googleUserIsVerified.toString());
      });
    }
    for (int i = 0; i <= 10; i++) {
      v() async => setState(() {
        userGoogleAcc = FirebaseAuth.instance.currentUser;
        UserData.setUserData(FirebaseAuth.instance.currentUser!);
        debugPrint(UserData.googleUserEmail);
        debugPrint(UserData.googleUserName);
        debugPrint(UserData.googleUserUID);
        debugPrint(UserData.googleUserPhotoURL);
        debugPrint(UserData.googleUserIsVerified.toString());
      });
      await v();
    }

    var person = await Hive.openBox("ALL");
    await person.put("AutoPlay", false);
    await person.put("AutoSave", 5);

    debugPrint("After Authentication------------------------------");
    debugPrint(person.get("Role")?.toString());
    debugPrint(person.get("AutoPlay", defaultValue: false)?.toString());
    debugPrint(person.get("AutoSave", defaultValue: 5)?.toString());
  }

  void loadStudentLearningFromDataBase() => loadCourseForStudent = FirebaseFirestore.instance
      .collection("StudentDB")
      .doc(UserData.googleUserEmail)
      .collection("Current Joined")
      .snapshots();

  getReadAsync() => allCourseRead = FirebaseControls.readAllCourse();

  loadOrRefreshFromDataBase() => loadCourse = FirebaseFirestore.instance.collection("CourseDB").snapshots();

  Widget buildGetAuthView() {
    return Placeholder(
      child: Scaffold(
        backgroundColor: AppTheme.pCon,
        body: SafeArea(
          child: Stack(
            children: [
              const BackGroundWithGradientEffect(),
              Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 17.5),
                  color: AppTheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 0.0),
                              child: Hero(
                                tag: "splash",
                                child: Card(
                                  child: SizedBox(
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: SizedBox(
                                        height: AppTheme.screenWidthInPortrait(context) * 0.125,
                                        width: AppTheme.screenWidthInPortrait(context) * 0.125,
                                        child: Image.asset("files/images/app_logo.png", fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                              child: Text(
                                "Welcome!!",
                                style: AppTheme.t3HeadlineSmall(
                                  context,
                                )!.copyWith(color: AppTheme.onSecondary, fontWeight: FontWeight.bold, letterSpacing: 5.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5 + 20.0),
                        Container(
                          width: 275.0,
                          height: 185.0,
                          padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 7.50),
                          decoration: BoxDecoration(color: AppTheme.onPrimary, borderRadius: const BorderRadius.all(Radius.circular(15.0))),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Sign In as",
                                  style: AppTheme.t4TitleLarge(
                                    context,
                                  )!.copyWith(color: AppTheme.primary, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: box.listenable(keys: ['Role']),
                                  builder: (context, box, child) => ToggleButtons(
                                    direction: Axis.vertical,
                                    borderRadius: BorderRadius.circular(12.50),
                                    borderWidth: 2.0,
                                    focusColor: AppTheme.primary,
                                    fillColor: AppTheme.secondary,
                                    selectedColor: AppTheme.secondary,
                                    selectedBorderColor: AppTheme.secondary,
                                    disabledColor: AppTheme.tertiary,
                                    disabledBorderColor: AppTheme.tertiary,
                                    textStyle: AppTheme.t4TitleLarge(context)!.copyWith(color: AppTheme.primary, fontWeight: FontWeight.bold),
                                    isSelected: UserData.currentRole,
                                    onPressed: (ind) => setState(() {
                                      UserData.currentRole = [false, false];
                                      UserData.currentRole[ind] = !UserData.currentRole[ind];
                                      (ind == 0) ? box.put("Role", Role.student) : box.put("Role", Role.courseOrganiser);
                                    }),
                                    children: [
                                      SizedBox(
                                        width: 225.0,
                                        child: Center(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              RoleToString.student,
                                              maxLines: 1,
                                              style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                color: (UserData.currentRole[0]) ? AppTheme.onSecondary : AppTheme.primary,
                                                letterSpacing: (UserData.currentRole[0]) ? 2.0 : 1.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 225.0,
                                        child: Center(
                                          child: SingleChildScrollView(
                                            physics: const ScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              RoleToString.courseOrganiser, //"Course Organiser",
                                              maxLines: 1,
                                              style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                color: (UserData.currentRole[1]) ? AppTheme.onSecondary : AppTheme.primary,
                                                letterSpacing: (UserData.currentRole[1]) ? 2.0 : 1.0,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                        ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        const Divider(indent: 28.50, endIndent: 28.50, thickness: 2.0, height: 20.0 + 12.0 + 2.0 + 0.5),
                        // const SizedBox(
                        //   height: 12.0,
                        // ),
                        Text(
                          "Account Options:",
                          style: AppTheme.t5TitleMedium(
                            context,
                          )!.copyWith(color: AppTheme.onSecondary, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                        ),
                        const SizedBox(
                          height: 10.0, //12.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17.5, vertical: 7.5),
                          // TODO: sign in button
                          child: GestureDetector(
                            onTap: () async {
                              getAuthAndRouteToHome();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 7.50),
                              decoration: BoxDecoration(color: AppTheme.onPrimary, borderRadius: const BorderRadius.all(Radius.circular(15.0))),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 00, 0.0),
                                      child: Container(
                                        color: Colors.transparent,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image.asset(
                                            "files/images/google_logo.png",
                                            height: AppTheme.screenWidthInPortrait(context) * 0.1, //50.0,
                                            width: AppTheme.screenWidthInPortrait(context) * 0.1, //50.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(width: 25.0),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 12.0),
                                        child: Center(
                                          child: TextMarquee(
                                            "Continue with Google",
                                            style: AppTheme.t5TitleMedium(
                                              context,
                                            )!.copyWith(color: AppTheme.primary, fontWeight: FontWeight.bold, letterSpacing: 1.5),
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
                        const Padding(padding: EdgeInsets.only(top: 13.0)),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: AppTheme.primary,
                  child: SizedBox(
                    width: AppTheme.screenWidthInPortrait(context),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            const TextSpan(text: "By Continuing, You Agree to our "),
                            TextSpan(
                              text: "Terms and Conditions",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(
                                  context,
                                ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const TCPrivacyPolicy())),
                              style: AppTheme.t8LabelMedium(context)!.copyWith(fontWeight: FontWeight.w700, color: Colors.blue, letterSpacing: 1.5),
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(
                                  context,
                                ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const TCPrivacyPolicy())),
                              style: AppTheme.t8LabelMedium(context)!.copyWith(fontWeight: FontWeight.w700, color: Colors.blue, letterSpacing: 1.5),
                            ),
                            const TextSpan(text: "."),
                          ],
                          style: AppTheme.t8LabelMedium(
                            context,
                          )!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onPrimary, letterSpacing: 1.5),
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
    );
  }

  Widget buildHomeView() {
    return PreDefinedDrawer(
      adc: _adc,
      childWidget: Scaffold(
        backgroundColor: AppTheme.pCon,
        body: SafeArea(
          child: Stack(
            children: [
              const BackGroundWithGradientEffect(),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: (UserData.googleUserName == "ERR") ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            if (UserData.googleUserName == "ERR")
                              GestureDetector(
                                onTap: () => Navigator.of(
                                  context,
                                ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const AppProfileSettings())),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(25.0, 30.0, 25.0, AppTheme.screenHeightInPortrait(context) * 1.50),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.5),
                                      border: Border.all(width: 3.50, color: AppTheme.error),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 15.0),
                                      child: SizedBox(
                                        width: AppTheme.screenWidthInPortrait(context),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Something Went Wrong...",
                                                style: AppTheme.t5TitleMedium(context)!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.error),
                                              ),
                                              TextSpan(
                                                text: "\nPlease Restart The App.",
                                                style: AppTheme.t6TitleSmall(context)!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.error),
                                              ),
                                              TextSpan(
                                                text: "\n\nWhat went wrong:\n'Authentication was not initiated.'\n",
                                                style: AppTheme.t7LabelLarge(context)!.copyWith(color: AppTheme.error),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ValueListenableBuilder(
                              valueListenable: box.listenable(keys: ['Role']),
                              builder: (context, box, child) {
                                String role = RoleToString.student; //"Student";
                                role = box.get('Role', defaultValue: RoleToString.student);
                                loadStudentLearningFromDataBase();
                                loadOrRefreshFromDataBase();
                                getReadAsync();
                                return Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.fromLTRB(2.5, 0.0, 2.5, 0.0),
                                  child: (role == RoleToString.student)
                                      ? HomeStreamForStudent(
                                          // loadCourseForStudent: loadCourseForStudent,
                                          // allCourseRead: allCourseRead,
                                          // loadCourse: loadCourse,
                                          // bgColor: bgColor,
                                        )
                                      : HomeStreamForCourseOrganiser(
                                          // loadCourseForStudent: loadCourseForStudent,
                                          // allCourseRead: allCourseRead,
                                          // loadCourse: loadCourse,
                                          // bgColor: bgColor,
                                        ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) => AppbarCard(
                  adc: _adc,
                  titleAppBar: AppTheme.appName,
                  menu: ConnectionNotifierToggler(
                    connected: GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const AppProfileSettings())),
                      child: Card(
                        elevation: 5.0,
                        child: SizedBox(
                          height: Theme.of(context).textTheme.displayMedium?.fontSize,
                          width: Theme.of(context).textTheme.displayMedium?.fontSize,
                          child: Stack(
                            children: [
                              Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(
                                  UserData.googleUserPhotoURL,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) =>
                                      (loadingProgress == null) ? child : const Center(child: CircularProgressIndicator()),
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) => Center(
                                    child: Icon(
                                      Icons.person,
                                      color: AppTheme.primary,
                                      size: Theme.of(context).textTheme.displayMedium!.fontSize! - 13.50,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  child: Card(
                                    color: AppTheme.primary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.settings_outlined, color: AppTheme.onPrimary, size: 12.50),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    loading: GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const AppProfileSettings())),
                      child: Card(
                        elevation: 5.0,
                        child: SizedBox(
                          height: Theme.of(context).textTheme.displayMedium?.fontSize,
                          width: Theme.of(context).textTheme.displayMedium?.fontSize,
                          child: Stack(
                            children: [
                              Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(
                                  UserData.googleUserPhotoURL,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) =>
                                      (loadingProgress == null) ? child : const Center(child: CircularProgressIndicator()),
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) => Center(
                                    child: Icon(
                                      Icons.person,
                                      color: AppTheme.primary,
                                      size: Theme.of(context).textTheme.displayMedium!.fontSize! - 13.50,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  child: Card(
                                    color: AppTheme.primary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.settings_outlined, color: AppTheme.onPrimary, size: 12.50),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    disconnected: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          title: Text(
                            'No Internet at this Time...',
                            style: AppTheme.t6TitleSmall(context)?.copyWith(
                              fontFamily: 'SourGummy',
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onPrimary,
                              // color: Colors.deepPurple,
                            ),
                          ),
                          content: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(
                                  context,
                                ).push(PageAnimationTransition(pageAnimationType: RightToLeftTransition(), page: const TCPrivacyPolicy())),
                              text:
                                  "Check Your Connections and Try again Later. ${AppTheme.appName} requires a efficient and smooth Network connection for Accessing the Real-Time Data.\nView 'About Us' for More Information.",
                              style: AppTheme.t8LabelMedium(context)?.copyWith(
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.onPrimary,
                                // color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              clipBehavior: Clip.antiAlias,
                              child: Text(
                                "Ok",
                                style: AppTheme.t7LabelLarge(context)?.copyWith(letterSpacing: 1, fontWeight: FontWeight.bold, color: AppTheme.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Card(
                        color: AppTheme.error,
                        child: SizedBox(
                          height: Theme.of(context).textTheme.displayMedium?.fontSize,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.signal_wifi_connected_no_internet_4,
                                size: Theme.of(context).textTheme.headlineMedium?.fontSize,
                                color: AppTheme.onError,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  menuChildren: const SizedBox(height: 0, width: 0),
                  showBackButton: false,
                  showMoreOption: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot snapshotAuthentication) => (snapshotAuthentication.hasData) ? buildHomeView() : buildGetAuthView(),
    );
  }
}
