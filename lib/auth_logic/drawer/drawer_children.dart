import 'package:dock_learner/auth_logic/firebase_controls.dart';
import 'package:dock_learner/auth_logic/profile_settings/profile_settings.dart';
import 'package:dock_learner/core/data_model/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';

import '../../app_info/about.dart';
import '../../core/data_model/role_data_model.dart';
import '../../core/theme_set/theme_colors.dart';
import '../../course_logic_role/action_logic/course_controls/create/create_course.dart';
import '../../course_logic_role/action_logic/listview_layouts/all_courses.dart';
import '../../course_logic_role/action_logic/listview_layouts/my_courses.dart';
import '../../course_logic_role/viewer_logic/listview_layouts/all_courses.dart';
import '../../course_logic_role/viewer_logic/listview_layouts/completed_courses.dart';
import '../../course_logic_role/viewer_logic/listview_layouts/current_courses.dart';
import 'extracted_widget.dart';

class DrawerChildrenWidget extends StatefulWidget {
  const DrawerChildrenWidget({super.key});

  @override
  State<DrawerChildrenWidget> createState() => _DrawerChildrenWidgetState();
}

class _DrawerChildrenWidgetState extends State<DrawerChildrenWidget> {
  late final Box box;

  @override
  void initState() {
    box = Hive.box('ALL');
    super.initState();
  }

  String formatDisplayName() {
    String name = UserData.googleUserName; //userGoogleAcc?.displayName ?? "USER NAME";
    if (name.length >= 17) {
      int firstSpace = name.indexOf(' ');
      int secondSpace = name.indexOf(' ', firstSpace + 1);
      if (secondSpace != -1) {
        return '${name.substring(0, secondSpace)}\n${name.substring(secondSpace + 1)}';
      }
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: box.listenable(keys: ['Role']),
      builder: (context, box, child) {
        final String role = box.get('Role', defaultValue: RoleToString.student);
        return Padding(
          padding: const EdgeInsets.fromLTRB(12.50, 50.0, 12.50, 7.50),
          child: (UserData.googleUserName == "ERR")
              ? Card(
                  elevation: 5,
                  color: AppTheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Something Went Wrong...",
                            style: AppTheme.t4TitleLarge(context)!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onSecondary),
                          ),
                          TextSpan(
                            text: "\nPlease Restart The App.",
                            style: AppTheme.t4TitleLarge(context)!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onSecondary),
                          ),
                          TextSpan(
                            text: "\nWhat went wrong: 'Google Authentication'.",
                            style: AppTheme.t7LabelLarge(context)!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Card(
                      elevation: 5,
                      color: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      // userGoogleAcc?.photoURL ?? "",
                                      width: AppTheme.t4TitleLarge(context)!.fontSize! + 10,
                                      //40.0,
                                      height: AppTheme.t4TitleLarge(context)!.fontSize! + 10,
                                      //40.0,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(child: CircularProgressIndicator());
                                      },
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Center(child: Icon(Icons.person, size: 40.0, color: AppTheme.onPrimary));
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 1.0, 8.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        formatDisplayName(),
                                        style: AppTheme.t5TitleMedium(context)!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 2.5 + AppTheme.t5TitleMedium(context)!.fontSize!,
                                          color: AppTheme.onSecondary,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 2.5, color: AppTheme.onPrimary),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  UserData.googleUserEmail,
                                  // userGoogleAcc!.email.toString(), //?? "EMAIL-ID",
                                  style: AppTheme.t7LabelLarge(context)!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onSecondary),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                role,
                                textAlign: TextAlign.left,
                                style: AppTheme.t6TitleSmall(context)!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  color: AppTheme.onSecondary,
                                  // color: Colors.blueGrey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    (role == RoleToString.student)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 45.0),
                            child: Column(
                              children: [
                                DisplayActionMenuForEach(
                                  textToDisplay: "All Courses",
                                  navigateToMaterialPageRoute: const ViewCoursesFromFirebaseDB(),
                                  transitionMethod: RightToLeftTransition(),
                                ),
                                DisplayActionMenuForEach(
                                  textToDisplay: "My Learning",
                                  navigateToMaterialPageRoute: const ResumeViewForEachCourseDetailsStudents(),
                                  transitionMethod: RightToLeftTransition(),
                                ),
                                StreamBuilder(
                                  stream: FirebaseControls.readCompletedCourse(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    return snapshot.hasData && snapshot.data!.docs.length > 0
                                        ? DisplayActionMenuForEach(
                                            textToDisplay: "Certifications",
                                            navigateToMaterialPageRoute: const ViewAllCompletedCourses(),
                                            transitionMethod: RightToLeftTransition(),
                                          )
                                        : const SizedBox.shrink();
                                  },
                                ),
                                DisplayActionMenuForEach(
                                  textToDisplay: "Settings",
                                  navigateToMaterialPageRoute: const AppProfileSettings(),
                                  transitionMethod: RightToLeftTransition(),
                                ),
                                DisplayActionMenuForEach(
                                  textToDisplay: "About Us",
                                  navigateToMaterialPageRoute: const AboutUs(),
                                  transitionMethod: RightToLeftTransition(),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 45.0),
                            child: Column(
                              children: [
                                DisplayActionMenuForEach(
                                  textToDisplay: "Create Course",
                                  navigateToMaterialPageRoute: const AddCourseToCloudDatabase(),
                                  transitionMethod: RightToLeftTransition(),
                                ),
                                DisplayActionMenuForEach(
                                  textToDisplay: "Organise Courses",
                                  navigateToMaterialPageRoute: const ViewOrganizingMyCoursesDetails(),
                                  transitionMethod: RightToLeftTransition(),
                                ),
                                DisplayActionMenuForEach(
                                  textToDisplay: "All Courses",
                                  navigateToMaterialPageRoute: const ViewOrganizingAllCoursesDetails(),
                                  transitionMethod: RightToLeftTransition(),
                                ),
                                DisplayActionMenuForEach(
                                  textToDisplay: "Settings",
                                  navigateToMaterialPageRoute: const AppProfileSettings(),
                                  transitionMethod: RightToLeftTransition(),
                                ),
                                DisplayActionMenuForEach(
                                  textToDisplay: "About Us",
                                  navigateToMaterialPageRoute: const AboutUs(),
                                  transitionMethod: RightToLeftTransition(),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
        );
      },
    );
  }
}
