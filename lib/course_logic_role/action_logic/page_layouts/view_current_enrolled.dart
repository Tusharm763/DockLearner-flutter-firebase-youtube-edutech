import 'package:flutter/material.dart';
import '../../../core/theme_set/theme_colors.dart';

class EnrolledStudents extends StatefulWidget {
  final List<dynamic> listStudents;
  final List<dynamic> listProgress;

  const EnrolledStudents({super.key, required this.listStudents, required this.listProgress});

  @override
  State<EnrolledStudents> createState() => _EnrolledStudentsState();
}

class _EnrolledStudentsState extends State<EnrolledStudents> {
  bool showMore = false;
  ScrollController scrollCon = ScrollController();

  String calculateEnrolled() {
    int w = 0;
    for (var i in widget.listProgress) {
      if (i.toString() == "ENROLLED") {
        w++;
      }
    }
    return w.toString();
  }

  String calculateCompleted() {
    int i = 0;
    for (var w in widget.listProgress) {
      if (w.toString() == "COMPLETED") {
        i++;
      }
    }
    return i.toString();
  }

  Center showNumberWithText(String num, String content) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: num,
              style: AppTheme.t3HeadlineSmall(context)!.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                fontSize: -1.50 + AppTheme.t4TitleLarge(context)!.fontSize!,
                color: AppTheme.onPrimary,
              ),
            ),
            TextSpan(text: "\n\n$content"),
          ],
          style: AppTheme.t6TitleSmall(context)!.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            // fontSize: 25.0,
            color: AppTheme.onPrimary,
          ),
        ),
      ),
    );
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
                padding: const EdgeInsets.fromLTRB(10.0, 75.0, 10.0, 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 2.50),
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 5.75,
                    interactive: true,
                    radius: const Radius.circular(5.0),
                    controller: scrollCon,
                    child: ListView.builder(
                      controller: scrollCon,
                      itemCount: widget.listStudents.length + 1,
                      itemBuilder: (BuildContext context, itemIndex) {
                        return (itemIndex != 0)
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(15.0, 3.0, 15.0, 3.0),
                                child: Card(
                                  color: AppTheme.primary,
                                  child: ListTile(
                                    title: Text(
                                      "$itemIndex.  ${widget.listStudents[itemIndex - 01]}",
                                      textAlign: TextAlign.left,
                                      style: AppTheme.t5TitleMedium(context)!.copyWith(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                        fontSize: 2.0 + AppTheme.t5TitleMedium(context)!.fontSize!,
                                        color: AppTheme.onPrimary,
                                      ),
                                    ),
                                    subtitle: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Current Status:  ",
                                            style: AppTheme.t6TitleSmall(
                                              context,
                                            )!.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1, color: AppTheme.onPrimary),
                                          ),
                                          TextSpan(
                                            text: widget.listProgress[itemIndex - 01].toString(),
                                            style: AppTheme.t4TitleLarge(context)!.copyWith(
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1,
                                              fontSize: -1.50 + AppTheme.t4TitleLarge(context)!.fontSize!,
                                              color: AppTheme.onPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () => setState(() => showMore = !showMore),
                                  child: Card(
                                    color: AppTheme.primary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  showNumberWithText(widget.listStudents.length.toString(), "Total"),
                                                  VerticalDivider(color: AppTheme.onPrimary, thickness: 1.50),
                                                  showNumberWithText(calculateEnrolled(), "Enrolled"),
                                                  VerticalDivider(color: AppTheme.onPrimary, thickness: 1.50),
                                                  showNumberWithText(calculateCompleted(), "Completed"),
                                                ],
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration: const Duration(seconds: 1),
                                              child: Visibility(
                                                visible: showMore,
                                                maintainAnimation: true,
                                                maintainState: true,
                                                child: Divider(height: 30.0, color: AppTheme.onPrimary, thickness: 2.0),
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration: const Duration(seconds: 1),
                                              child: Visibility(
                                                visible: showMore,
                                                maintainState: true,
                                                maintainAnimation: true,
                                                child: RichText(
                                                  textAlign: TextAlign.justify,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "ENROLLED : ",
                                                        style: AppTheme.t4TitleLarge(context)!.copyWith(
                                                          fontWeight: FontWeight.w700,
                                                          letterSpacing: 1,
                                                          fontSize: -1.50 + AppTheme.t4TitleLarge(context)!.fontSize!,
                                                          color: AppTheme.onPrimary,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: "\nHe/she has just started the Course Journey.",
                                                        style: AppTheme.t6TitleSmall(
                                                          context,
                                                        )!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onPrimary),
                                                      ),
                                                      TextSpan(
                                                        text: "\n\n",
                                                        style: AppTheme.t7LabelLarge(context)!.copyWith(
                                                          fontWeight: FontWeight.w700,
                                                          letterSpacing: 1,
                                                          // fontSize: -1.50 + AppTheme.t4TitleLarge(context)!.fontSize!,
                                                          color: AppTheme.onPrimary,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: "COMPLETED :",
                                                        style: AppTheme.t4TitleLarge(context)!.copyWith(
                                                          fontWeight: FontWeight.w700,
                                                          letterSpacing: 1,
                                                          fontSize: -1.50 + AppTheme.t4TitleLarge(context)!.fontSize!,
                                                          color: AppTheme.onPrimary,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "\nHe/she has Completed All the Course Journey Lectures, And All Verification are WithHeld to Terms and Conditions.",
                                                        style: AppTheme.t6TitleSmall(
                                                          context,
                                                        )!.copyWith(fontWeight: FontWeight.w700, color: AppTheme.onPrimary),
                                                      ),
                                                    ],
                                                    style: AppTheme.t6TitleSmall(
                                                      context,
                                                    )!.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1, color: AppTheme.onPrimary),
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
                              );
                      },
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  return AppbarCard(
                    adc: null,
                    titleAppBar: "Enrolled Students",
                    menu: GestureDetector(
                      onTap: () => setState(() => showMore = !showMore),
                      child: Card(
                        elevation: 5.0,
                        child: SizedBox(
                          height: Theme.of(context).textTheme.displayMedium?.fontSize,
                          width: Theme.of(context).textTheme.displayMedium?.fontSize,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Card(
                                color: AppTheme.primary,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Center(child: Icon((!showMore) ? Icons.more_vert : Icons.close, color: AppTheme.onPrimary)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    menuChildren: const SizedBox(height: 0, width: 0),
                    showBackButton: true,
                    showMoreOption: true,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
