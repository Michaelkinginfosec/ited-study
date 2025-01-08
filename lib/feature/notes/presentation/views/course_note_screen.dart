// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/constants/boxsize.dart';
import 'package:ited_study/core/constants/text_style.dart.dart';
import 'package:ited_study/feature/notes/domain/model/topics.dart';
import '../../../../core/route/route.dart';

class CourseNoteScreen extends StatefulWidget {
  final String courseTitle;
  final String courseCode;
  final String courseId;
  const CourseNoteScreen({
    super.key,
    required this.courseTitle,
    required this.courseCode,
    required this.courseId,
  });

  @override
  State<CourseNoteScreen> createState() => _CourseNoteScreenState();
}

class _CourseNoteScreenState extends State<CourseNoteScreen> {
  List<Topics> topics = [];
  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  void fetchTopics() async {
    loadStoredTopics();
  }

  void loadStoredTopics() async {
    // Open the Hive box
    final box = Hive.box<Topics>('topic');
    final allTopics = box.values.toList();

    setState(
      () {
        topics = allTopics
            .where((topic) => topic.courseId == widget.courseId)
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.courseTitle,
          style: CustomTextStyles.mediumSubtitleText,
        ),
        centerTitle: false,
      ),
      body: Column(
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
                    "Topics",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.general);
                },
                child: Container(
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
                      "Past Questions",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 5, 45, 1),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          CustomSizeBox.smallBox,
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      context.push(
                        AppRoutes.note,
                        extra: topics[index].id,
                      );
                    },
                    child: Ink(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(topics[index].topic),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
