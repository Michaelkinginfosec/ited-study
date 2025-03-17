import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/config/style/boxsize.dart';
import 'package:ited_study/feature/pastQuestions/presentation/widgets/number_container.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/config/style/text_style.dart.dart';

class CbtPractice extends StatefulWidget {
  final String course;
  final String lenght;
  final String time;
  const CbtPractice({
    super.key,
    required this.course,
    required this.lenght,
    required this.time,
  });

  @override
  State<CbtPractice> createState() => _CbtPracticeState();
}

class _CbtPracticeState extends State<CbtPractice> {
  List cbtQuestion = [];
  bool showContainer = false;
  List<bool> isAnswered = [];
  int currentQuestionIndex = 0;
  int remainingTimeInSeconds = 0;
  Timer? countdownTimer;
  List<String?> selectedOptions = [];
  int answeredCount = 0;
  // String? selectedOptions;
  @override
  void initState() {
    super.initState();
    fetchQuestion();

    String cleanedTime = widget.time.replaceAll(RegExp(r'[^0-9]'), '');
    remainingTimeInSeconds = int.parse(cleanedTime) * 60;

    startCountdownTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdownTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTimeInSeconds <= 0) {
        timer.cancel();
        performTimeExceededAction();
      } else {
        setState(() {
          remainingTimeInSeconds--;
        });
      }
    });
  }

  void performTimeExceededAction() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Up'),
        content: const Text('The time for this section has expired.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void fetchQuestion() {
    var box = Hive.box('examQuestion');
    cbtQuestion = box.values
        .where((element) => element['courseId'] == widget.course)
        .toList();

    cbtQuestion = cbtQuestion.isEmpty
        ? [
            {'message': 'No questions found'}
          ]
        : cbtQuestion;

    selectedOptions = List<String?>.filled(cbtQuestion.length, null);
    isAnswered = List<bool>.filled(cbtQuestion.length, false);
  }

  void navigateToNextQuestion() {
    if (currentQuestionIndex < cbtQuestion.length - 1) {
      setState(() {
        currentQuestionIndex++;
        showContainer = false;
      });
    }
  }

  void navigateToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        showContainer = false;
      });
    }
  }

  void onOptionSelected(String label) {
    setState(() {
      selectedOptions[currentQuestionIndex] = label;

      if (!isAnswered[currentQuestionIndex]) {
        isAnswered[currentQuestionIndex] = true;
        answeredCount++;
      }
    });
  }

  void jumpToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
      showContainer = false;
    });
  }

  void submitAnswers() {
    List<Map<String, dynamic>> userAnswers = [];
    for (int i = 0; i < cbtQuestion.length; i++) {
      userAnswers.add({
        'question': cbtQuestion[i]['question'],
        'selectedOption': selectedOptions[i],
        'correctOption': cbtQuestion[i]['correctAnswer'],
        'isCorrect': selectedOptions[i] == cbtQuestion[i]['correctAnswer'],
      });
    }

    int correctAnswers =
        userAnswers.where((answer) => answer['isCorrect'] == true).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Answers'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'You answered $correctAnswers out of ${cbtQuestion.length} questions correctly.'),
              const SizedBox(height: 10),
              ...userAnswers.map((answer) => ListTile(
                    title: Text(answer['question']),
                    subtitle: Text(
                      'Your Answer: ${answer['selectedOption'] ?? 'Not Attempted'}\nCorrect Answer: ${answer['correctOption']}',
                    ),
                    trailing: Icon(
                      answer['isCorrect'] ? Icons.check_circle : Icons.cancel,
                      color: answer['isCorrect'] ? Colors.green : Colors.red,
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Exits to the previous screen.
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = cbtQuestion[currentQuestionIndex];
    var options = currentQuestion['options'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Cyber Security",
              style: CustomTextStyles.mediumSubtitleText,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 75),
            child: GestureDetector(
              onTap: submitAnswers,
              child: Container(
                width: 91,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 5, 45, 1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    "submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomSizeBox.mediumBox,
              cbtQuestion.length >= int.parse(widget.lenght)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${currentQuestionIndex + 1} / ${widget.lenght}",
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${currentQuestionIndex + 1}/${cbtQuestion.length}",
                        ),
                      ),
                    ),
              LinearPercentIndicator(
                lineHeight: 8.0,
                percent: answeredCount / cbtQuestion.length,
                animation: true,
                progressColor: const Color.fromRGBO(0, 45, 5, 1),
                barRadius: const Radius.circular(20),
              ),
              CustomSizeBox.mediumBox,
              Center(
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color.fromRGBO(0, 45, 5, 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/images/watch.png'),
                      Center(
                        child: Text(
                          formatTime(remainingTimeInSeconds),
                          style: CustomTextStyles.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomSizeBox.mediumBox,
              Card(
                elevation: 10,
                clipBehavior: Clip.hardEdge,
                child: Container(
                  width: double.infinity,
                  height: 450,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question ${currentQuestionIndex + 1}",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 5, 45, 1),
                          ),
                        ),
                        CustomSizeBox.smallBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            currentQuestion['question'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 5, 45, 1),
                            ),
                          ),
                        ),
                        CustomSizeBox.smallBox,
                        Column(
                          children: options.map<Widget>((option) {
                            bool isSelected =
                                selectedOptions[currentQuestionIndex] ==
                                    option['label'];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => onOptionSelected(option['label']),
                                child: Row(
                                  children: [
                                    Text(
                                      option['label'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(0, 5, 45, 1),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 2,
                                          color:
                                              const Color.fromRGBO(0, 5, 45, 1),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color.fromRGBO(
                                                    0, 5, 45, 1)
                                                : Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        option['text'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(0, 5, 45, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const Spacer(),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Fundamentals of Cyber security",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              CustomSizeBox.smallBox,
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(
              //         () {
              //           showContainer = !showContainer;
              //         },
              //       );
              //     },
              //     child: const Text(
              //       "Show Explanation",
              //       style: TextStyle(
              //         fontSize: 12,
              //         fontWeight: FontWeight.bold,
              //         color: Color.fromRGBO(0, 5, 45, 1),
              //       ),
              //     ),
              //   ),
              // ),
              // CustomSizeBox.mediumBox,
              // if (showContainer == true) ...[
              //   const ExplanationBox(
              //     explanation:
              //         " The concept of tenses is related. It can be classified as IMPORTANT AND RESILLENCE",
              //   ),
              //   CustomSizeBox.smallBox,
              // ],

              CustomSizeBox.smallBox,
              Row(
                children: [
                  GestureDetector(
                    onTap: navigateToPreviousQuestion,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(0, 5, 45, 1),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Previous",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 5, 45, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: navigateToNextQuestion,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromRGBO(0, 5, 45, 1),
                      ),
                      child: const Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CustomSizeBox.smallBox,
              const Text(
                "Attempted Questions",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 5, 45, 1),
                ),
              ),
              const Divider(
                thickness: 1,
                color: Color.fromRGBO(0, 5, 45, 1),
              ),
              SizedBox(
                height: 300,
                child: GridView.builder(
                  itemCount: int.parse(widget.lenght) >= cbtQuestion.length
                      ? cbtQuestion.length
                      : int.parse(widget.lenght),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => jumpToQuestion(index),
                      child: NumberContainer(
                        number: (index + 1).toString(),
                        color: isAnswered[index]
                            ? const Color.fromRGBO(0, 5, 45, 0.6)
                            : Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
