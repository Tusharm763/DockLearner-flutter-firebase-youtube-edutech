import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class UserData {
  static List<bool> currentRole = [false, false];
  static String googleUserUID = "ERR";
  static String googleUserName = "ERR";
  static String googleUserEmail = "ERR";
  static String googleUserPhotoURL = "ERR";
  static bool googleUserIsVerified = false;

  static Future<void> setUserData(User userData) async {
    googleUserUID = userData.uid;
    googleUserName = userData.displayName!;
    googleUserEmail = userData.email!;
    googleUserPhotoURL = userData.photoURL!;
    googleUserIsVerified = userData.emailVerified;
  }

  static Future<void> reSetUserData() async {
    googleUserUID = "ERR";
    googleUserName = "ERR";
    googleUserEmail = "ERR";
    googleUserPhotoURL = "ERR";
    googleUserIsVerified = false;
  }

  static Future<bool> isStudent() async {
    Box<dynamic> hiveDB = await Hive.openBox("All");
    return (hiveDB.get("roleHive").toString() == "Student");
  }

  static Future<bool> isCourseOrganiser() async {
    Box<dynamic> hiveDB = await Hive.openBox("All");
    return (hiveDB.get("roleHive").toString() == "Course Organiser");
  }
}
