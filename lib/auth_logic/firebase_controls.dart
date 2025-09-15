import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dock_learner/core/data_model/user_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../core/theme_set/snack_theme.dart';

class FirebaseControls {
  static late final FirebaseApp app;
  static late final FirebaseAuth auth;
  static User? userGoogleAcc = FirebaseAuth.instance.currentUser;

  static void startCourse(context, courseData) async {
    // var person = await Hive.openBox("ALL");
    int totalLectures = 0;
    for (var i in courseData["Id"]) {
      debugPrint(i);
      totalLectures++;
    }
    // Map<String, dynamic> course = {
    //   "Title": courseData["Title"],
    //   "Description": courseData["Description"],
    //   "Author": courseData["Author"],
    //   "Id": courseData["Id"],
    //   "Length": courseData["Length"],
    //   "Users": courseData["Users"],
    //   "Progress": courseData["Progress"],
    // };

    List usersTillNow = courseData["Users"];
    List progressTillNow = courseData["Progress"];

    bool needUpgrade = true;
    for (var i in courseData["Users"]) {
      if ("$i" == UserData.googleUserName) {
        needUpgrade = false;
      }
    }

    if (needUpgrade) {
      usersTillNow.add(UserData.googleUserName);
      // usersTillNow.add("${userGoogleAcc?.displayName}");
      progressTillNow.add("ENROLLED");
    }
    // FirebaseFirestore.instance.collection("CourseDB").doc(courseData["Title"]).update(
    //   {
    //     "Users": usersTillNow,
    //     "Progress": progressTillNow,
    //   },
    // ).then((value) {});
    //TODO: Firebase Update for student
    int totalVideoLen = 0;
    for (var i in courseData["Length"]) {
      totalVideoLen += int.parse(i.toString());
    }
    int autoPlayAfter = 10;
    if (((totalVideoLen / totalLectures) / 3600).toDouble() >= 1) {
      autoPlayAfter = 3;
    } else if (((totalVideoLen / totalLectures) / 3600).toDouble() >= 0.5) {
      autoPlayAfter = 5;
    }

    FirebaseFirestore.instance
        .collection("StudentDB")
        .doc(UserData.googleUserEmail)
        // .doc(userGoogleAcc?.email)
        .collection("Current Joined")
        .doc(courseData["Title"])
        .set({
          "Title": courseData["Title"],
          "Description": courseData["Description"],
          "Author": courseData["Author"],
          "Id": courseData["Id"],
          "LT": courseData["LT"],
          "Length": courseData["Length"],
          "Progress": List.filled(totalLectures, "0"),
          "AutoPlay": "N",
          "AutoSave": autoPlayAfter.toString(),
        })
        .then(
          //TODO: Firebase Update for Course Organiser
          (value) => FirebaseFirestore.instance
              .collection("CourseDB")
              .doc(courseData["Title"])
              .update({"Users": usersTillNow, "Progress": progressTillNow})
              .then((value) async {
                bool hasRecent = false;
                final docRef = FirebaseFirestore.instance
                    .collection("StudentDB")
                    .doc(UserData.googleUserEmail)
                    // .doc("${userGoogleAcc!.email}")
                    .collection("Recents")
                    .doc("Recents");
                await FirebaseFirestore.instance.runTransaction((transaction) async {
                  try {
                    // TODO: if 'Recent' is defined and Not Null
                    final snapshot = await transaction.get(docRef);
                    List<dynamic> currentRecent = List.empty(growable: true);
                    debugPrint("List Get Success");
                    currentRecent = snapshot.get("Recents") as List<dynamic>;

                    hasRecent = true;
                    currentRecent.remove(courseData["Title"]);
                    currentRecent.insert(0, courseData["Title"]);
                    transaction.update(docRef, {"Recents": currentRecent.toList(growable: true)});
                  } catch (e) {
                    // TODO: if 'Recent' is not defined and is Null
                    debugPrint("List Get Failed");
                    if (!hasRecent) {
                      List<dynamic> currentRecent = List.empty(growable: true);
                      currentRecent.add(courseData["Title"]);
                      debugPrint("\n\nin set the Recent state\n\n");
                      await FirebaseFirestore.instance
                          .collection("StudentDB")
                          .doc(UserData.googleUserEmail)
                          // .doc("${userGoogleAcc!.email}")
                          .collection("Recents")
                          .doc("Recents")
                          .set({"Recents": currentRecent});
                    }
                  }
                });
              }),
        )
        .then((value) {});
    //TODO: OFFLINE - Hive for student
    // myCoursesHive.add(course);
    // person.put("mycourse", myCoursesHive);
  }

  static bool isCourseCompleted(List<dynamic> users, List<dynamic> info) {
    int indexInUsers = -1;
    for (int i = 0; i < users.length; i++) {
      if (users[i].toString() == UserData.googleUserName) {
        // if (users[i].toString() == userGoogleAcc!.displayName.toString()) {
        indexInUsers = i;
        break;
      }
    }
    debugPrint(info[indexInUsers]);
    return (info[indexInUsers] == "COMPLETED") ? false : true;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> readAllCourse() => FirebaseFirestore.instance.collection("CourseDB").snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> readRecentCourse() => FirebaseFirestore.instance
      .collection("StudentDB")
      .doc(UserData.googleUserEmail)
      // .doc(userGoogleAcc!.email.toString())
      .collection("Recents")
      .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> readCompletedCourse() => FirebaseFirestore.instance
      .collection("StudentDB")
      .doc(UserData.googleUserEmail)
      // .doc(userGoogleAcc!.email.toString())
      .collection("Completed")
      .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> readCurrentCourse() => FirebaseFirestore.instance
      .collection("StudentDB")
      .doc(UserData.googleUserEmail)
      // .doc(userGoogleAcc!.email.toString())
      .collection("Current Joined")
      .snapshots();

  static Future addCourseToFirebaseCourseDB(BuildContext context, String courseTitle, Map<String, dynamic> videoData) async => await FirebaseFirestore
      .instance
      .collection("CourseDB")
      .doc(courseTitle)
      .set(videoData)
      .then((value) => ShowSnackInfo.success(contentText: "Course Created Successfully...").show(context));

  static Future deleteCourseFromFirebaseCourseDB(String courseTitle) async {
    return await FirebaseFirestore.instance.collection("CourseDB").doc(courseTitle).delete();
  }

  static Future deleteAllCoursesFromStudentDB() async {
    return await null; //FirebaseFirestore.instance.collection("StudentDB").doc(userGoogleAcc!.email.toString()).collection("Current Joined")..delete();
  }

  static Future deleteCourseFromFirebaseStudentDBCurrentJoined(String courseTitle) async {
    return await FirebaseFirestore.instance
        .collection("StudentDB")
        .doc(UserData.googleUserEmail)
        // .doc(userGoogleAcc!.email.toString())
        .collection("Current Joined")
        .doc(courseTitle)
        .delete()
        .then((value) {
          debugPrint("DocumentSnapshot successfully updated!");
          final docRef = FirebaseFirestore.instance
              .collection("StudentDB")
              .doc(UserData.googleUserEmail)
              // .doc("${userGoogleAcc!.email}")
              .collection("Recents")
              .doc("Recents");
          FirebaseFirestore.instance.runTransaction((transaction) async {
            final snapshot = await transaction.get(docRef);
            List<dynamic> currentRecent = snapshot.get("Recents");
            currentRecent.remove(courseTitle);
            transaction.update(docRef, {"Recents": currentRecent.toList(growable: true)});
          });
        });
  }

  static Future<void> deleteUserAndProgressFromFirebaseCourseDB(String courseTitle) async {
    try {
      final docRef = FirebaseFirestore.instance.collection("CourseDB").doc(courseTitle);
      FirebaseFirestore.instance
          .runTransaction((transaction) async {
            final snapshot = await transaction.get(docRef);
            try {
              List<dynamic> previousUsers = snapshot.get("Users");
              List<dynamic> previousProgress = snapshot.get("Progress");
              int j = 0;
              for (var i in snapshot.get("Users")) {
                if (i == UserData.googleUserName) {
                  // if (i == userGoogleAcc!.displayName) {
                  j = previousUsers.indexOf(i);
                  break;
                }
              }
              debugPrint(j.toString());
              if (previousProgress[j] == "ENROLLED") {
                previousUsers.removeAt(j);
                previousProgress.removeAt(j);
              }
              transaction.update(docRef, {
                "Users": List.generate(previousUsers.length, (index) => previousUsers[index], growable: true),
                "Progress": List.generate(previousProgress.length, (index) => previousProgress[index], growable: true),
              });
            } catch (e) {
              debugPrint("No users");
            }
          })
          .then((value) => debugPrint("DocumentSnapshot successfully updated!"), onError: (e) => debugPrint("Error updating document $e"));
    } catch (e) {
      debugPrint("Course Data deleted from Author.");
    }
  }

  static Future<void> checkForCourseCompletedAndUpdateFirebaseCourseDB(String courseTitle) async {
    bool isCompleted = true;
    final docRefStudent = FirebaseFirestore.instance
        .collection("StudentDB")
        .doc(UserData.googleUserEmail)
        // .doc(userGoogleAcc!.email.toString())
        .collection("Current Joined")
        .doc(courseTitle);

    FirebaseFirestore.instance
        .runTransaction((transaction) async {
          final snapshot = await transaction.get(docRefStudent);
          for (var i in snapshot.get("Progress")) {
            if (i.toString() != "100") {
              isCompleted = false;
              break;
            }
          }
        })
        .then(
          (value) => debugPrint((isCompleted) ? "\n\n\nCompleted" : "\n\n\nNot Completed"),
          onError: (e) => debugPrint("Error updating document $e"),
        );
    if (isCompleted) {
      final docRef = FirebaseFirestore.instance.collection("CourseDB").doc(courseTitle);
      FirebaseFirestore.instance
          .runTransaction((transaction) async {
            final snapshot = await transaction.get(docRef);
            List<dynamic> previousUsers = snapshot.get("Users");
            List<dynamic> previousProgress = snapshot.get("Progress");
            int j = 0;
            for (var i in previousUsers) {
              if (i == UserData.googleUserName) {
                // if (i == userGoogleAcc!.displayName) {
                j = previousUsers.indexOf(i);
                break;
              }
            }
            debugPrint(j.toString());
            previousProgress[j] = "Completed";
            transaction.update(docRef, {"Progress": List.generate(previousProgress.length, (index) => previousProgress[index], growable: true)});
          })
          .then((value) => debugPrint("Course:  DocumentSnapshot successfully updated!"), onError: (e) => debugPrint("Error updating document $e"));
    }
  }
}
