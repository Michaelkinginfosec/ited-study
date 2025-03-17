// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/config/style/boxsize.dart';
import 'package:ited_study/core/config/style/text_style.dart.dart';
import '../../../../core/config/routes/route.dart';
import '../../domain/model/courses.dart';
import '../widgets/course_tile.dart';

class CourseScreen extends ConsumerStatefulWidget {
  const CourseScreen({super.key});

  @override
  ConsumerState<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends ConsumerState<CourseScreen> {
  List<Courses> courses = [];
  bool? isActivated;

  @override
  void initState() {
    getCourses();
    getUser();
    super.initState();
  }

  void getCourses() async {
    final box = await Hive.openBox<Courses>('courses');
    setState(() {
      courses = box.values.toList();
    });
  }

  void getUser() async {
    final box = await Hive.openBox('usersBox');
    final user = box.get('users');
    if (user != null) {
      setState(() {
        isActivated = user.activated ?? false;
      });
    } else {
      setState(() {
        isActivated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color.fromRGBO(0, 5, 45, 1),
                    ),
                    child: Center(
                      child: Text(
                        "Courses",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   height: 40,
                //   width: 150,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(40),
                //     border: Border.all(
                //       width: 1,
                //       color: Color.fromRGBO(0, 5, 45, 1),
                //     ),
                //     color: Colors.white,
                //   ),
                //   child: Center(
                //     child: Text(
                //       "Completed",
                //       style: TextStyle(
                //         color: Color.fromRGBO(0, 5, 45, 1),
                //         fontWeight: FontWeight.w700,
                //         fontSize: 15,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
            CustomSizeBox.mediumBox,
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  bool isCourseAccessable = isActivated == true || index == 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: isCourseAccessable
                        ? GestureDetector(
                            onTap: () {
                              final courseTile = courses[index].courseTitle;
                              final courseCode = courses[index].courseCode;
                              final courseId = courses[index].id;
                              context.push(AppRoutes.coursenote, extra: {
                                "courseTitle": courseTile,
                                "courseCode": courseCode,
                                "courseId": courseId
                              });
                            },
                            child: CustomListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: courses[index].courseImage,
                                  height: 100,
                                  width: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Course Title",
                                    style: CustomTextStyles.secondtinyBody,
                                  ),
                                  Text(
                                    courses[index].courseName,
                                    style: CustomTextStyles.mediumSubtitleText,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Course Code",
                                    style: CustomTextStyles.secondtinyBody,
                                  ),
                                  Text(
                                    courses[index].courseCode,
                                    style: CustomTextStyles.mediumSubtitleText,
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(CupertinoIcons.bookmark_fill),
                                  Icon(
                                    CupertinoIcons.lock_open,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : CustomListTile(
                            leading: CachedNetworkImage(
                              imageUrl: courses[index].courseImage,
                              height: 100,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Course Title",
                                  style: CustomTextStyles.secondtinyBody,
                                ),
                                Text(
                                  courses[index].courseName,
                                  style: CustomTextStyles.mediumSubtitleText,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Course Code",
                                  style: CustomTextStyles.secondtinyBody,
                                ),
                                Text(
                                  courses[index].courseCode,
                                  style: CustomTextStyles.mediumSubtitleText,
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(CupertinoIcons.bookmark_fill),
                                Icon(CupertinoIcons.lock_fill),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
