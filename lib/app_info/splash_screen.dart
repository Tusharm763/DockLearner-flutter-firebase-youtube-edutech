import 'dart:async';
import 'package:flutter/material.dart';
import '../auth_logic/home_screen.dart';
import '../core/theme_set/theme_colors.dart';

class SplashScreenV2 extends StatefulWidget {
  const SplashScreenV2({super.key});

  @override
  State<SplashScreenV2> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenV2> {
  @override
  void initState() {
    Timer(
      const Duration(milliseconds: 2500),
      () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomeScreenUserLoggedIn())),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
                  child: Hero(
                    tag: "splash",
                    child: Card(
                      elevation: 2,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: SizedBox(
                        height: AppTheme.screenWidthInPortrait(context) * 0.19,
                        width: AppTheme.screenWidthInPortrait(context) * 0.19,
                        child: Image.asset("files/images/app_logo.png", fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Welcome',
                  style: AppTheme.t3HeadlineSmall(context)!.copyWith(color: AppTheme.onPrimary, letterSpacing: 3.0, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 15.0),
                Text(
                  AppTheme.appName,
                  style: AppTheme.t1HeadlineLarge(context)!.copyWith(color: AppTheme.onPrimary, letterSpacing: 5.0, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.0, width: 30.0, child: Image.asset("files/images/firebase_logo.png")),
                    const SizedBox(width: 5),
                    Text(
                      "FireBase",
                      style: AppTheme.t7LabelLarge(context)!.copyWith(color: AppTheme.onPrimary, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                    ),
                    const VerticalDivider(thickness: 1.5, width: 40.0),
                    SizedBox(height: 30.0, width: 30.0, child: Image.asset("files/images/youtube_logo.png", color: Colors.red)),
                    const SizedBox(width: 6.50),
                    Text(
                      "Youtube",
                      style: AppTheme.t7LabelLarge(context)!.copyWith(color: AppTheme.onPrimary, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
