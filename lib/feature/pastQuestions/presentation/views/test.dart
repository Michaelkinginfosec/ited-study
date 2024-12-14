import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ited_study/core/constants/boxsize.dart';
import 'package:ited_study/core/route/route.dart';
import 'package:ited_study/feature/pastQuestions/presentation/widgets/dropdownformfield.dart';

class TestQuestion extends StatefulWidget {
  const TestQuestion({super.key});

  @override
  State<TestQuestion> createState() => _TestQuestionState();
}

class _TestQuestionState extends State<TestQuestion> {
  List<String> years = [
    "2015",
    "2016",
    "2018",
    "2019",
    "2020",
    "2021",
    "2022",
    "2023"
  ];
  List<String> courses = ["CSC202", "CYB202", "CYB201", "CSC201", "CIT202"];
  List<String> topics = [
    "boolean Algebrae",
    "vector space",
    "linear equation",
  ];
  String? selectedYear;
  String? selectedCourse;
  String? selectedTopic;
  final _formKey = GlobalKey<FormState>();
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
                label: "Year",
                items: years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue;
                  });
                },
                value: selectedYear,
                validator: (String? value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              CustomSizeBox.mediumBox,
              CustomDropDownFormField(
                label: "Topics",
                items: topics.map<DropdownMenuItem<String>>((String value) {
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
                    selectedTopic = newValue;
                  });
                },
                value: selectedTopic,
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
                  context.push(
                    AppRoutes.testquestionscreen,
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
                      "Questions",
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
