import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/config/boxsize.dart';
import 'package:ited_study/core/route/route.dart';
import '../../../notes/domain/model/courses.dart';
import '../../../notes/domain/model/topics.dart';
import '../widgets/dropdownformfield.dart';

class ExamCbtMode extends StatefulWidget {
  const ExamCbtMode({super.key});

  @override
  State<ExamCbtMode> createState() => _ExamCbtModeState();
}

class _ExamCbtModeState extends State<ExamCbtMode> {
  List<String> questionLenght = ["25", "30", "45", "60"];
  List<String> time = ["10m", "20m", "30m", "60m"];
  List<String> courses = [];
  List<String> topics = [];
  String? selectedLenght;
  String? selectedCourse;
  String? selectedTime;
  String? courseId;
  String? topicId;

  final _formKey = GlobalKey<FormState>();

  void fetchCourses() {
    var box = Hive.box('textCourse');
    courses = box.values.toList().cast<String>();
  }

  void fetchTopics() {
    if (selectedCourse != null) {
      var box = Hive.box<Courses>('courses');
      courseId = box.values
          .firstWhere((element) => element.courseCode == selectedCourse)
          .id;
      if (courseId != null) {
        var box = Hive.box<Topics>("topic");
        topics = box.values
            .where((element) => element.courseId == courseId)
            .map((e) => e.topic)
            .toList();
      }
    }
  }

  @override
  void initState() {
    fetchCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomDropDownFormField(
                label: "Course",
                items: courses.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCourse = newValue;
                    fetchTopics();
                  });
                },
                value: selectedCourse,
                validator: (String? value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              CustomSizeBox.mediumBox,
              CustomDropDownFormField(
                label: "Question ",
                items: questionLenght
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLenght = newValue;
                  });
                },
                value: selectedLenght,
                validator: (String? value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              CustomSizeBox.mediumBox,
              CustomDropDownFormField(
                label: "Time",
                items: time.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTime = newValue;
                  });
                },
                value: selectedTime,
                validator: (String? value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              CustomSizeBox.extralBig,
              GestureDetector(
                onTap: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  context.push(
                    AppRoutes.cbtpractice,
                    extra: {
                      'lenght': selectedLenght,
                      'time': selectedTime,
                      'course': courseId
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 5, 45, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Practice",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
