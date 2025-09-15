import 'package:dock_learner/course_logic_role/action_logic/page_layouts/view_course_details.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../core/theme_set/snack_theme.dart';
import '../../core/theme_set/theme_colors.dart';

class RenderListTileForOrganisingMyCourses extends StatelessWidget {
  const RenderListTileForOrganisingMyCourses({super.key, required this.snapshot, required this.currentIndex, required this.bgColor});

  final dynamic snapshot;
  final int currentIndex;
  final List<Color> bgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          PageAnimationTransition(
            pageAnimationType: RightToLeftTransition(),
            page: ViewEachForCourseOrganiser(courseData: snapshot.data.docs[currentIndex]),
          ),
        ),
        onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(courseSnackBar(context, snapshot.data.docs[currentIndex])),
        child: SizedBox(
          height: 150.0 * 9 / 16,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(17.50, 0.0, 17.50, 0.0),
            child: Card(
              color: AppTheme.primary,
              margin: EdgeInsets.zero,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 000.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0.0,
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: bgColor[currentIndex],
                          borderRadius: BorderRadius.circular(12.5),
                          border: Border.all(width: 2.0, color: AppTheme.onPrimary),
                        ),
                        height: 125.0 * 9 / 16,
                        width: 125.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9.50),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  'https://img.youtube.com/vi/${snapshot.data.docs[currentIndex]["Id"][0]}/hqdefault.jpg',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) =>
                                      (loadingProgress == null) ? child : const CircularProgressIndicator(),
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) =>
                                      Center(child: Icon(Icons.import_contacts, color: AppTheme.onPrimary, size: 45.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - 125.0 - 10.0 - 50.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: SizedBox(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    snapshot.data.docs[currentIndex]["Title"].toString(),
                                    style: AppTheme.t4TitleLarge(context)!.copyWith(color: AppTheme.onPrimary, letterSpacing: 0.5),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            RichText(
                              text: (snapshot.data.docs[currentIndex]["Users"].length > 0)
                                  ? TextSpan(
                                      children: [
                                        const TextSpan(text: "Enrolled : "),
                                        TextSpan(
                                          text: snapshot.data.docs[currentIndex]["Users"].length.toString(),
                                          style: AppTheme.t4TitleLarge(context)!.copyWith(
                                            fontSize: 0 + AppTheme.t4TitleLarge(context)!.fontSize!,
                                            color: AppTheme.onPrimary,
                                            letterSpacing: 0.8,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const TextSpan(text: " Students"),
                                      ],
                                      style: AppTheme.t5TitleMedium(context)!.copyWith(color: AppTheme.onPrimary, fontWeight: FontWeight.normal),
                                    )
                                  : TextSpan(
                                      children: const [TextSpan(text: "New Course!!")],
                                      style: AppTheme.t5TitleMedium(context)!.copyWith(color: AppTheme.onPrimary, fontWeight: FontWeight.normal),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RenderCardForCourseOrganiserLikeForAllCourseView extends StatelessWidget {
  const RenderCardForCourseOrganiserLikeForAllCourseView({
    super.key,
    required this.bgColor,
    required this.data,
    required this.courseTitle,
    required this.indexOfCourse,
  });

  final List<Color> bgColor;
  final dynamic data;
  final int indexOfCourse;
  final String courseTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageAnimationTransition(
          pageAnimationType: RightToLeftTransition(),
          page: ViewEachForCourseOrganiser(courseData: data[indexOfCourse]),
        ),
      ),
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(courseSnackBar(context, data[indexOfCourse]));
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7.50, 0.0, 7.50, 10.0),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 5.0,
            color: AppTheme.primary,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17.50))),
            child: Container(
              height: (MediaQuery.of(context).size.width * 9 / 16) * 0.9,
              width: (MediaQuery.of(context).size.width * 16 / 9) * 0.9,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.transparent, AppTheme.secondary], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.circular(17.50),
                border: Border.all(width: 2.50, color: AppTheme.primary),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.50),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        'https://img.youtube.com/vi/${data[indexOfCourse]["Id"][0]}/hqdefault.jpg',
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Center(child: Icon(Icons.import_contacts, color: AppTheme.onPrimary, size: 45.0));
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.secondary.withValues(alpha: 0.225),
                              AppTheme.secondary.withValues(alpha: 0.45),
                              AppTheme.secondary.withValues(alpha: 0.9),
                              AppTheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 12.50,
                      right: 12.50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              data[indexOfCourse]["Title"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.t3HeadlineSmall(
                                context,
                              )!.copyWith(color: AppTheme.onPrimary, fontWeight: FontWeight.w700, letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
