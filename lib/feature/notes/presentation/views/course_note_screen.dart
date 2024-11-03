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
  final String course;
  const CourseNoteScreen({
    super.key,
    required this.course,
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
    final box = await Hive.openBox<Topics>('topics');

    print("Fetching topics from Hive, box length: ${box.length}");

    // Retrieve all stored values as a List
    setState(() {
      topics = box.values.toList(); // Fetch all stored topics
      print("Fetched topics length: ${topics.length}");

      // Debug: Print each topic's courseId and topic
      for (var topic in topics) {
        print("Fetched topic: ${topic.courseId} -> ${topic.topic}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(topics.length);
    // print(topics.length);
    // print(topics[0].topic);
    // print(topics[1].topic);
    // print(topics[2].topic);
    // print(topics[3].topic);
    // print(topics[4].topic);
    // print(topics[5].topic);
    // print(topics[6].topic);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.course,
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
                    "Past Questions",
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
                      context.push(AppRoutes.note);
                    },
                    child: Ink(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
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
