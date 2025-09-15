import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class AppTheme {
  static String appName = "DockLearner";
  static String currentVersion = "1.0.0";
  static Brightness themeBrightness = Brightness.light;
  static Color currentColorTheme = Colors.indigo;
  static String? currentTextFamily = 'SourGummy';

  static double screenHeightInPortrait(context) => MediaQuery.sizeOf(context).height;

  static double screenWidthInPortrait(context) => MediaQuery.sizeOf(context).width;

  static double screenHeightInLandscape(context) => MediaQuery.sizeOf(context).width;

  static double screenWidthInLandscape(context) => MediaQuery.sizeOf(context).height;

  static TextStyle? t1HeadlineLarge(context) => Theme.of(context).textTheme.headlineLarge!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t2HeadlineMedium(context) => Theme.of(context).textTheme.headlineMedium!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t3HeadlineSmall(context) => Theme.of(context).textTheme.headlineSmall!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t4TitleLarge(context) => Theme.of(context).textTheme.titleLarge!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t5TitleMedium(context) => Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t6TitleSmall(context) => Theme.of(context).textTheme.titleSmall!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t7LabelLarge(context) => Theme.of(context).textTheme.labelLarge!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t8LabelMedium(context) => Theme.of(context).textTheme.labelMedium!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t9LabelSmall(context) => Theme.of(context).textTheme.labelSmall!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t10BodyLarge(context) => Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t11BodyMedium(context) => Theme.of(context).textTheme.bodyMedium!.copyWith(fontFamily: currentTextFamily);

  static TextStyle? t12BodySmall(context) => Theme.of(context).textTheme.bodySmall!.copyWith(fontFamily: currentTextFamily);

  static Color primary = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).primary;
  static Color onPrimary = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).onPrimary;
  static Color secondary = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).secondary;
  static Color onSecondary = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).onSecondary;
  static Color tertiary = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).tertiary;
  static Color onTertiary = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).onTertiary;

  static Color surface = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).surface;
  static Color surfaceTint = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).surfaceTint;
  static Color error = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).error;
  static Color onError = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).onError;

  static Color onPCon = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).onPrimaryContainer;
  static Color onSCon = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).onSecondaryContainer;
  static Color onTCon = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).onTertiaryContainer;

  static Color pCon = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).primaryContainer;
  static Color sCon = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).secondaryContainer;
  static Color tCon = ColorScheme.fromSeed(seedColor: currentColorTheme, brightness: themeBrightness).tertiaryContainer;
}

class CustomStyleForTextFormField {
  static TextStyle? formFieldTextStyle(BuildContext context) {
    return AppTheme.t8LabelMedium(context)?.copyWith(fontWeight: FontWeight.bold, fontFamily: 'SourGummy', letterSpacing: 1.5);
  }

  static InputDecoration formFieldDecoration(BuildContext context, IconData thisPrefixIcon, String thisHintText) {
    return InputDecoration(
      hintText: thisHintText,
      iconColor: AppTheme.onPrimary,
      filled: true,
      icon: Icon(thisPrefixIcon, size: 20.0, fill: 1.0),
      border: const UnderlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: AppTheme.tertiary, width: 5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: AppTheme.secondary, width: 4),
      ),
    );
  }
}

class AppbarCard extends StatefulWidget {
  const AppbarCard({
    super.key,
    required this.titleAppBar,
    required this.menu,
    required this.menuChildren,
    required this.showBackButton,
    required this.showMoreOption,
    required this.adc,
  });

  final String titleAppBar;
  final bool showBackButton;
  final bool showMoreOption;
  final Widget menuChildren;
  final Widget menu;
  final AdvancedDrawerController? adc;

  @override
  State<AppbarCard> createState() => _AppbarCardState();
}

class _AppbarCardState extends State<AppbarCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 010.0, left: 10.0, right: 10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => (widget.showBackButton) ? Navigator.pop(context) : widget.adc?.toggleDrawer(),
                      child: Card(
                        elevation: 5.0,
                        child: SizedBox(
                          height: Theme.of(context).textTheme.displayMedium?.fontSize,
                          width: Theme.of(context).textTheme.displayMedium?.fontSize,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(child: Icon((widget.showBackButton) ? Icons.arrow_back : Icons.menu, color: AppTheme.primary)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Card(
                      elevation: 5.0,
                      child: SizedBox(
                        height: Theme.of(context).textTheme.displayMedium?.fontSize,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18.0, 10.0, 15.0, 10.0),
                          child: Center(
                            child: Text(
                              widget.titleAppBar,
                              style: AppTheme.t6TitleSmall(context)?.copyWith(
                                fontFamily: 'SourGummy',
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                                // color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  // width: double.infinity,
                  // width: (MediaQuery.sizeOf(context).width * 1 / 10) -
                  //     15,
                  child: SizedBox(),
                ),
                (widget.showMoreOption) ? widget.menu : const SizedBox.shrink(),
              ],
            ),
            (widget.showMoreOption) ? const SizedBox(height: 5.0) : const SizedBox(height: 0, width: 0),
            widget.menuChildren,
          ],
        ),
      ),
    );
  }
}

class BackGroundWithGradientEffect extends StatelessWidget {
  const BackGroundWithGradientEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.screenWidthInPortrait(context),
      height: AppTheme.screenHeightInPortrait(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.secondaryContainer,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            Theme.of(context).colorScheme.secondaryContainer,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),

            /// Theme.of(context).colorScheme.secondaryContainer,
            //// Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.15),
            ///// Theme.of(context).colorScheme.secondaryContainer,
            /////  Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.4),
            // Theme.of(context).colorScheme.secondaryContainer,
            /////  Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            // AppTheme.primary,
            // Colors.transparent,
            // Colors.transparent.withValues(alpha: 0),
            // Colors.transparent,
            // AppTheme.secondary.withValues(alpha: 0.9999),
            // AppTheme.secondary,
            // AppTheme.primary,
          ],
        ),
      ),
    );
  }
}
