// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/config/style/boxsize.dart';
import '../../../core/config/style/text_style.dart.dart';

class CalculateCGPAScreen extends StatefulWidget {
  const CalculateCGPAScreen({super.key});

  @override
  State<CalculateCGPAScreen> createState() => _CalculateCGPAScreenState();
}

List<RowData> rows = [];
final TextEditingController _staticCourseController = TextEditingController();
final TextEditingController _staticUnitController = TextEditingController();
final TextEditingController _staticGradeController = TextEditingController();

class _CalculateCGPAScreenState extends State<CalculateCGPAScreen> {
  final A = 5;
  final B = 4;
  final C = 3;
  final D = 2;
  final E = 1;
  final F = 0;

  List<double> cgpaList = [];
  double firstSemesterGP = 0.00;
  double secondSemesterGP = 0.00;
  double currentGP = 0.00;
  int totalUnit = 21;
  String semester = 'first';
  Color color = const Color.fromRGBO(181, 178, 178, 1);

  void calculateCGPA(String staticGrade, List<String> nonStaticGrades) async {
    if (!mounted) return;
    setState(() {
      cgpaList.clear();
      staticGrade = staticGrade.toUpperCase();

      int staticGradeWeight;

      switch (staticGrade) {
        case 'A':
          staticGradeWeight = A;
          break;
        case 'B':
          staticGradeWeight = B;
          break;
        case 'C':
          staticGradeWeight = C;
          break;
        case 'D':
          staticGradeWeight = D;
          break;
        case 'E':
          staticGradeWeight = E;
          break;
        case 'F':
          staticGradeWeight = F;
          break;
        default:
          return;
      }

      for (int i = 0; i < rows.length; i++) {
        String nonStaticGrade = nonStaticGrades[i].toUpperCase();
        int nonStaticGradeWeight;

        switch (nonStaticGrade) {
          case 'A':
            nonStaticGradeWeight = A;
            break;
          case 'B':
            nonStaticGradeWeight = B;
            break;
          case 'C':
            nonStaticGradeWeight = C;
            break;
          case 'D':
            nonStaticGradeWeight = D;
            break;
          case 'E':
            nonStaticGradeWeight = E;
            break;
          case 'F':
            nonStaticGradeWeight = F;
            break;
          default:
            return;
        }

        double nonStaticValue =
            double.parse(rows[i].unitController.text) * nonStaticGradeWeight;
        cgpaList.add(nonStaticValue);
      }

      final staticValue =
          double.parse(_staticUnitController.text) * staticGradeWeight;
      cgpaList.add(staticValue);
    });

    if (mounted) {
      double sum = cgpaList.reduce((a, b) => a + b);
      final cgpa = sum / totalUnit;
      if (semester == 'first' || semester == 'First') {
        var box = Hive.box('gp');
        await box.put('firstSemester', firstSemesterGP);
        setState(() {
          firstSemesterGP = double.parse(cgpa.toStringAsFixed(2));
        });
      } else if (semester == 'second' || semester == "Second") {
        var box = Hive.box('gp');
        await box.put('secondSemester', secondSemesterGP);
        setState(() {
          secondSemesterGP = double.parse(cgpa.toStringAsFixed(2));
        });
      }
    }
  }

  void addRow() {
    setState(() {
      rows.add(RowData(
        courseController: TextEditingController(),
        unitController: TextEditingController(),
        gradeController: TextEditingController(),
      ));
    });
  }

  // @override
  // void dispose() {
  //   _staticCourseController.dispose();
  //   _staticUnitController.dispose();
  //   _staticGradeController.dispose();
  //   for (var row in rows) {
  //     row.courseController.dispose();
  //     row.unitController.dispose();
  //     row.gradeController.dispose();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Text(
              "100 Level",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(0, 5, 45, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter"),
            ),
            const Text(
              "Enter your grades to calculate your GP",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(181, 178, 178, 1),
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
            CustomSizeBox.smallBox,
            Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 5, 45, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        semester = 'first';
                        color = const Color.fromRGBO(181, 178, 178, 1);
                        currentGP = secondSemesterGP;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: semester == 'first'
                            ? BorderRadius.circular(10)
                            : const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                        color: semester == 'first'
                            ? color
                            : const Color.fromRGBO(0, 5, 45, 1),
                      ),
                      child: Center(
                        child: Text(
                          "First Semester",
                          style: TextStyle(
                            color: semester == 'first'
                                ? const Color.fromRGBO(0, 5, 45, 1)
                                : color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          semester = 'second';
                          color = const Color.fromRGBO(181, 178, 178, 1);
                          currentGP = secondSemesterGP;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: semester == 'second'
                              ? BorderRadius.circular(10)
                              : const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                          color: semester == 'second'
                              ? color
                              : const Color.fromRGBO(0, 5, 45, 1),
                        ),
                        child: Center(
                          child: Text(
                            "Second Semester",
                            style: TextStyle(
                              color: semester == 'second'
                                  ? const Color.fromRGBO(0, 5, 45, 1)
                                  : color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              semester == 'first'
                  ? double.parse(firstSemesterGP.toString()).toStringAsFixed(2)
                  : double.parse(secondSemesterGP.toString())
                      .toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 50,
                color: Color.fromRGBO(0, 5, 45, 1),
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
              ),
            ),
            Text(
              "Total G.P.A for $semester semester",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(181, 178, 178, 1),
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
            CustomSizeBox.smallBox,
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 2.9 / 5,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 5, 45, 1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Course',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Unit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 1.3 / 5,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(37, 109, 3, 1),
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Center(
                                child: Text(
                                  'Grade',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                        CustomSizeBox.mediumBox,
                        StaticRowData(
                          courseController: _staticCourseController,
                          unitController: _staticUnitController,
                          gradeController: _staticGradeController,
                        ),
                        ...rows,
                        CustomSizeBox.mediumBox,
                        Center(
                          child: ElevatedButton(
                            onPressed: addRow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  CustomTextStyles.loginsignupButtonColor,
                              minimumSize: const Size(8, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              "Add More",
                              style: CustomTextStyles.buttonText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomSizeBox.mediumBox,
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String staticGrade = _staticGradeController.text;

                  List<String> nonStaticGrades = [];

                  for (var grade in rows) {
                    nonStaticGrades.add(grade.gradeController.text);
                  }

                  calculateCGPA(staticGrade, nonStaticGrades);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTextStyles.loginsignupButtonColor,
                  minimumSize: const Size(228, 41),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Calculate GP",
                  style: CustomTextStyles.buttonText,
                ),
              ),
            ),
            CustomSizeBox.box
          ],
        ),
      ),
    );
  }
}

class StaticRowData extends StatelessWidget {
  final TextEditingController courseController;
  final TextEditingController unitController;
  final TextEditingController gradeController;

  const StaticRowData({
    super.key,
    required this.courseController,
    required this.unitController,
    required this.gradeController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1.6 / 5,
                      height: 30,
                      child: TextFormField(
                        controller: courseController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: "Course",
                          contentPadding: EdgeInsets.all(3),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter course';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1.1 / 5,
                      height: 30,
                      child: TextFormField(
                        controller: unitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Unit",
                          contentPadding: EdgeInsets.all(3),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter unit';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1.3 / 5,
                  height: 30,
                  child: TextFormField(
                    controller: gradeController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "Grade",
                      contentPadding: EdgeInsets.all(3),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter grade';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RowData extends StatelessWidget {
  final TextEditingController courseController;
  final TextEditingController unitController;
  final TextEditingController gradeController;

  const RowData({
    super.key,
    required this.courseController,
    required this.unitController,
    required this.gradeController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1.6 / 5,
                      height: 30,
                      child: TextFormField(
                        controller: courseController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          hintText: "Course",
                          contentPadding: const EdgeInsets.all(3),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          enabled: true,
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Course';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1.1 / 5,
                      height: 30,
                      child: TextFormField(
                        controller: unitController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(3),
                          hintText: "Unit",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          enabled: true,
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Unit';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1.3 / 5,
                      height: 30,
                      child: TextFormField(
                        controller: gradeController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(3),
                          border: InputBorder.none,
                          hintText: "Grade",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          enabled: true,
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ' Grade';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
