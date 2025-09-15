import 'dart:core';

import 'package:dock_learner/app_info/widgets.dart';
import 'package:flutter/material.dart';
import '../core/theme_set/theme_colors.dart';

class TCPrivacyPolicy extends StatefulWidget {
  const TCPrivacyPolicy({super.key});

  @override
  State<TCPrivacyPolicy> createState() => _TCPrivacyPolicyState();
}

class _TCPrivacyPolicyState extends State<TCPrivacyPolicy> {
  bool readMore = false;

  @override
  void initState() {
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
                padding: const EdgeInsets.only(top: 65.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 1.0),
                    child: ListView(
                      children: [
                        const Padding(padding: EdgeInsets.all(5.0)),
                        const CardExpansionForEach(
                          textP: "Creating an Account",
                          content:
                              "The User Account, i.e., the Google Account is hereby considered for all the Progress and Activities of a User by means of E-Mail.\n\nThe Google and its Services are the Necessity of this application and in case of any Discrepancies, The google Account Authentication services will take part in Resolving the Issues related to it.\n\nAny User can Change his/Her Role of 'Signed-In As' and their is no rules and terms for that.\n\nThe User's E-Mail is the Primary Key to their Data. Anyone with the E-Mail Authentication can change/ Modify / Delete and type of Data, created by Users.",
                          iconsData: Icons.account_box_rounded,
                        ),
                        CardExpansionForEach(
                          textP: "Enrolling To a Course",
                          content:
                              "The Instructions for Enrolling to a Course on ${AppTheme.appName} are as followed :\n\n1. The Particular Course which the Student is Displayed is Real Time Based until the Student pressed the 'Enroll to this Course', i.e., On Clicking Enroll, the Student will get an instance of that Particular Course with the Course Parts- Sections, Other Information and Instruction by the Instructor.\n\n2. The Course will not change or be Real-Time Modifiable after Course Enrollment.\n\n3. The Modifications and Queries updated by the Course Instructor (Future  Scope) is only applicable for New Enrollments and not for the Current Enrolled Students.\n\n4. Note- Their is no restriction on how much times you (Student) Enrolled and Rolled-Out for a Course.",
                          iconsData: Icons.login,
                        ),
                        const CardExpansionForEach(
                          textP: "AutoPlay",
                          content:
                              "The AutoPlay Feature is an In-App Setting Feature and resets to 'OFF' on Account Logins. This will help the Users, i.e., Students to automatically start the Video as they go to the Lecture Section of the Particular Course.",
                          iconsData: Icons.auto_mode,
                        ),
                        const CardExpansionForEach(
                          textP: "AutoSave",
                          content:
                              "The AutoSave Feature is an In-App Setting Feature and resets to '3 %' on Account Logins/Sign-Up. This will help the Users, i.e., Students to Save the Progress after 3 or 5 or 10 % as selected by User. User should set this settings as per their Internet Connections. Recommended Settings is 5%.",
                          iconsData: Icons.autorenew,
                        ),
                        const CardExpansionForEach(
                          textP: "Youtube Video Seeks",
                          content:
                              "The Video Lecture is been monitored and Striated to save the Progress Ethically, The User, i.e., Student can seek behind to any Time Period of YouTube Video the Progress will remain unchanged.\n\nAt the same time, If User tries to seek ahead of the Progress Percentage, the Progress will not save the sought part's Progress, hence User will have to view/see each and every Second (Time Period) of the Video Lecture.\n\nAlso, When the User will go back from the Lecture Screen, the Progress will save the Progress again as to verify the Progress and Keep things Up-To-Dated.",
                          iconsData: Icons.percent_rounded,
                        ),
                        CardExpansionForEach(
                          textP: "About Certifications",
                          content:
                              "The Information for Certification from a Course on ${AppTheme.appName} are as followed :\n\n1. The Particular Course which the Student has Completed are Moved to Secured Storage, i.e., That Particular Course will Never be Modified, Delete or and other Control in any Course of Time.\n\n2. The Course Structure in the 'My Certifications' Courses are respective to the Changes in WYC-WGS (What-You-Completed- is -What-Gets-Saved), the Student Enrolled and Completed to that Course.",
                          iconsData: Icons.card_giftcard,
                        ),
                        CardExpansionForEach(
                          textP: "Rolling-Out Course",
                          content:
                              "The Instructions for Rolling-Out from a Course on ${AppTheme.appName} are as followed :\n\n1. The Particular Course which the Student wants to be Rolled-Out, will lose all the progress and Data related to Course at that particular, and the Course Structure will also be reset to the Current Course Structure, and Instructions as conducted by the Course Organiser.\n\n2. The Course Structure in the 'My Learning' Courses are respective to the Changes in WYS-WYG (What-You-See- is -What-You-Get), the Student Enrolled to that Course.",
                          iconsData: Icons.logout,
                        ),
                        CardExpansionForEach(
                          textP: "Creating a Course",
                          content:
                              "The Instructions for Creating a Course for Course Organiser in ${AppTheme.appName} are as followed :\n\n1. The Course which is to be Created must have a 'Unique Course Title' which will be verified on 'Continuing to Next' Step.\n\n2. The Course Structure in the Course should have Section Titles and Section wise, U.R.L. of the Section Video from Youtube.\n\nThe Information about this can be seen in the 'Help' section in 'Add New Course'.",
                          iconsData: Icons.create_new_folder,
                        ),
                        CardExpansionForEach(
                          textP: "Editing a Course",
                          content:
                              "The Instructions while Editing a Course  in ${AppTheme.appName} are as followed :\n\n1. The Course which is to be edited must have a the same 'Course Title' which will be verified on 'Continuing to Next' Step in the 'Add New Course'.\n\n2. The Course Structure in the Course should have all New (or re-use) Section Titles and Section wise, U.R.L. of the Section Video from Youtube.\n\nThe Editing Feature will only be allowed to the same Author as a verification for Editing that course, Therefore, if User ( Course Organiser) will try to edit Course from another Author, It will reject the Appeal to Edit at the same time.",
                          iconsData: Icons.create_new_folder,
                        ),
                        CardExpansionForEach(
                          textP: "Deleting a Course",
                          content:
                              "The Instructions for Deleting/Removing a Course from Course Organiser in ${AppTheme.appName} are as followed :\n\n1. The Course which is to be removed, will be deleted, and removed for New Student who wants to be enroll this Courses.\n\n2. The Course will not take any action such as delete/manipulate on the Students Course Progress, their Current Course Structure's version etc.\n\nThe Course Information about the Students and Student's Enrollment Status will be completely Deleted, will never be able to recover.",
                          iconsData: Icons.folder_delete,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) => const AppbarCard(
                  adc: null,
                  titleAppBar: "T&C and Privacy Policy",
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
