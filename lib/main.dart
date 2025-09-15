import 'dart:async';
import 'package:dock_learner/app_info/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import 'core/data_model/user_data_model.dart';
import 'core/constants.dart';
import 'core/theme_set/theme_colors.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
User? userGoogleAcc = FirebaseAuth.instance.currentUser;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("binding done");
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.initFlutter();
  await SettingsService.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppTheme.primary,
      systemNavigationBarColor: AppTheme.primary, //.withOpacity(0.5),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCm2bW9zjK7hgx_BZBeqJ-3-CEL-MMv64A",
        authDomain: "learning-yt-94f87.firebaseapp.com",
        projectId: "learning-yt-94f87",
        storageBucket: "learning-yt-94f87.firebasestorage.app",
        messagingSenderId: "1035837478438",
        appId: "1:1035837478438:web:5831fa67af05201f50f8e7",
        measurementId: "G-902VFWXVY6",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  try {
    userGoogleAcc = FirebaseAuth.instance.currentUser;
    await UserData.setUserData(FirebaseAuth.instance.currentUser!);
  } catch (e) {
    debugPrint("Firebase Error : userAuth :\n$e");
  }

  debugPrint(UserData.googleUserEmail);
  debugPrint(UserData.googleUserName);
  debugPrint(UserData.googleUserUID);
  debugPrint(UserData.googleUserPhotoURL);
  debugPrint(UserData.googleUserIsVerified.toString());

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }

  runApp(
    MaterialApp(
      title: AppTheme.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.currentColorTheme), useMaterial3: true),
      home: const SplashScreenV2(),
    ),
  );
}
