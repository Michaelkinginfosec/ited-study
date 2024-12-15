import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/constants/boxsize.dart';
import 'package:ited_study/core/constants/text_style.dart.dart';

class PastExamQuestionScreen extends StatefulWidget {
  final String selectedYear;
  final String topicId;
  final String courseId;
  const PastExamQuestionScreen(
      {super.key,
      required this.selectedYear,
      required this.topicId,
      required this.courseId});

  @override
  State<PastExamQuestionScreen> createState() => _PastExamQuestionScreenState();
}

class _PastExamQuestionScreenState extends State<PastExamQuestionScreen> {
  List testQuestion = [];

  @override
  void initState() {
    fetchQuestion();
    super.initState();
  }

  void fetchQuestion() {
    if (widget.selectedYear == "All") {
      var box = Hive.box('examQuestion');
      testQuestion = box.values
          .where((element) => element['topicId'] == widget.topicId)
          .toList();
      testQuestion = testQuestion.isEmpty
          ? [
              {'message': 'No questions found'}
            ]
          : testQuestion;
    } else {
      var box = Hive.box('examQuestion');
      testQuestion = box.values
          .where((element) =>
              element['topicId'] == widget.topicId &&
              element['year'] == widget.selectedYear)
          .toList();

      testQuestion = testQuestion.isEmpty
          ? [
              {'message': 'No questions found'}
            ]
          : testQuestion;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Past Questions",
          style: CustomTextStyles.normalTextSetting2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView.builder(
          itemCount: testQuestion.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      "${index + 1}.",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 5, 45, 1),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          testQuestion[index]['question'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 5, 45, 1),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(0, 5, 45, 1),
                            ),
                            child: Center(
                              child: Text(
                                testQuestion[index]['options'][0]['label'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(testQuestion[index]['options'][0]['text']),
                        ],
                      ),
                      CustomSizeBox.smallBox,
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(0, 5, 45, 1),
                            ),
                            child: Center(
                              child: Text(
                                testQuestion[index]['options'][1]['label'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(testQuestion[index]['options'][1]['text']),
                        ],
                      ),
                      CustomSizeBox.smallBox,
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(0, 5, 45, 1),
                            ),
                            child: Center(
                              child: Text(
                                testQuestion[index]['options'][2]['label'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(testQuestion[index]['options'][2]['text']),
                        ],
                      ),
                      CustomSizeBox.smallBox,
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(0, 5, 45, 1),
                              ),
                              child: Center(
                                child: Text(
                                  testQuestion[index]['options'][3]['label'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(testQuestion[index]['options'][3]['text']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 5, 45, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Check Answer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 5, 45, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Look up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomSizeBox.smallBox
              ],
            );
          },
        ),
      ),
    );
  }
}
