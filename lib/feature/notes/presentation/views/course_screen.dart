// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/constants/boxsize.dart';
import 'package:ited_study/core/constants/text_style.dart.dart';
import '../../../../core/route/route.dart';
import '../../domain/model/courses.dart';
import '../widgets/course_tile.dart';

class CourseScreen extends ConsumerStatefulWidget {
  const CourseScreen({super.key});

  @override
  ConsumerState<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends ConsumerState<CourseScreen> {
  List<Courses> courses = [];

  @override
  void initState() {
    getCourses();
    super.initState();
  }

  void getCourses() async {
    final box = await Hive.openBox<Courses>('courses');
    setState(() {
      courses = box.values.toList();
    });
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
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
                Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(0, 5, 45, 1),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      "Completed",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 5, 45, 1),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
            CustomSizeBox.mediumBox,
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: GestureDetector(
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
