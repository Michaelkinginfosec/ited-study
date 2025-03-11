import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/config/boxsize.dart';
import 'package:ited_study/core/config/text_style.dart.dart';
import '../../../../core/route/route.dart';

class PastTestQuestionScreen extends StatefulWidget {
  final String selectedYear;
  final String topicId;
  final String courseId;
  const PastTestQuestionScreen({
    super.key,
    required this.selectedYear,
    required this.topicId,
    required this.courseId,
  });

  @override
  State<PastTestQuestionScreen> createState() => _PastTestQuestionScreen();
}

class _PastTestQuestionScreen extends State<PastTestQuestionScreen> {
  List testQuestion = [];
  bool? isActivated;

  @override
  void initState() {
    fetchQuestion();
    getUser();
    super.initState();
  }

  void fetchQuestion() {
    try {
      var box = Hive.box('question');

      if (box.isEmpty || box.values.isEmpty) {
        testQuestion = [
          {'message': 'No questions found'}
        ];
        return;
      }

      if (widget.selectedYear == "All") {
        testQuestion = box.values
            .where((element) => element?['topicId'] == widget.topicId)
            .toList();
      } else {
        testQuestion = box.values
            .where((element) =>
                element?['topicId'] == widget.topicId &&
                element?['year'] == widget.selectedYear)
            .toList();
      }

      if (testQuestion.isEmpty) {
        testQuestion = [
          {'message': 'No questions found'}
        ];
      }

      setState(() {});
    } catch (e) {
      setState(() {
        testQuestion = [
          {'message': 'An error occurred while fetching questions'}
        ];
      });
    }
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
        title: const Text(
          "Past Test Questions",
          style: CustomTextStyles.normalTextSetting2,
        ),
      ),
      body: testQuestion.isEmpty
          ? const Center(
              child: Text("No questions found"),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  ...[
                    if (isActivated == false)
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.activate);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 5, 45, 1),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Activate the app to get access to all notes, past questions, and scholarships.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                  CustomSizeBox.mediumBox,
                  Expanded(
                    child: ListView.builder(
                      itemCount: isActivated == false
                          ? (testQuestion.length >= 3 ? 3 : testQuestion.length)
                          : testQuestion.length,
                      itemBuilder: (context, index) {
                        if (testQuestion.isEmpty) {
                          return const Center(
                            child: Text("No questions found"),
                          );
                        }
                        var question = testQuestion[index];
                        var options = question['options'] ?? [];
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
                                      question['question'] ?? "",
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
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              child: Column(
                                children: [
                                  if (options.length > 0)
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
                                              options[0]['label'] ?? "",
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
                                        Expanded(
                                          child: Text(options[0]['text'] ?? ""),
                                        ),
                                      ],
                                    ),
                                  CustomSizeBox.smallBox,
                                  if (options.length > 1)
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
                                              options[1]['label'] ?? "",
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
                                        Expanded(
                                          child: Text(options[1]['text'] ?? ""),
                                        ),
                                      ],
                                    ),
                                  CustomSizeBox.smallBox,
                                  if (options.length > 2)
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
                                              options[2]['label'] ?? "",
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
                                        Expanded(
                                          child: Text(options[2]['text'] ?? ""),
                                        ),
                                      ],
                                    ),
                                  CustomSizeBox.smallBox,
                                  if (options.length > 3)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Color.fromRGBO(0, 5, 45, 1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                options[3]['label'] ?? "",
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
                                          Expanded(
                                            child:
                                                Text(options[3]['text'] ?? ""),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Center(
                                                child: const Text("Answer")),
                                            content: Text(
                                              question['correctAnswer'] ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text("Close"))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(0, 5, 45, 1),
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
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Center(
                                                child:
                                                    const Text("Explanation")),
                                            content: Text(
                                              question['explanation'] ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text("Close"))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(0, 5, 45, 1),
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
                ],
              ),
            ),
    );
  }
}
