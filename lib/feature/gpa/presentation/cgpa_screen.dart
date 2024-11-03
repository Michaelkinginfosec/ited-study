// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/route/route.dart';

class CGPAScreen extends StatefulWidget {
  const CGPAScreen({super.key});

  @override
  State<CGPAScreen> createState() => _CGPAScreenState();
}

class _CGPAScreenState extends State<CGPAScreen> {
  double firstSemesterGP = 0.00;
  double secondSemesterGP = 0.00;
  double value = 0.00;
  @override
  void initState() {
    super.initState();
    getGP();
  }

  void getGP() {
    var box = Hive.box('gp');
    setState(() {
      firstSemesterGP = box.get('firstSemester') ?? 0.00;
      secondSemesterGP = box.get('secondSemester') ?? 0.00;
      value = box.get('cgpa') ?? 0.00;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "C.G.P.A Calculator",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text(
              "Calculate and keep record of your grades",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(181, 178, 178, 1),
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              value.toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 50,
                color: Color.fromRGBO(0, 5, 45, 1),
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
              ),
            ),
            const Text(
              "Total C.G.P.A",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(181, 178, 178, 1),
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(217, 217, 217, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "100 level",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(0, 5, 45, 1),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inter",
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "First Semester:",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 5, 45, 1),
                              ),
                            ),
                            Text(
                              '$firstSemesterGP',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 5, 45, 1),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Second Semester:",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 5, 45, 1),
                              ),
                            ),
                            Text(
                              '$secondSemesterGP',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 5, 45, 1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.push(AppRoutes.calculatecgpa);
                                },
                                child: Container(
                                  width: 71,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color.fromRGBO(0, 5, 45, 1),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Input",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    var box = Hive.box('gp');
                                    box.delete('cgpa');
                                    value = 0;
                                  });
                                },
                                child: Container(
                                  width: 71,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color.fromRGBO(248, 6, 6, 0.9),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "A man that fails to plan, planned to fail. Stay focused as the sky reamins your starting point.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(1, 1, 1, 1),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  var box = Hive.box('gp');
                  box.clear();
                  final totalGPA = (firstSemesterGP + secondSemesterGP) / 2;
                  box.put('cgpa', totalGPA);
                  value = box.get('cgpa');
                });
              },
              child: Container(
                width: 208,
                height: 31,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromRGBO(0, 5, 45, 1),
                ),
                child: const Center(
                  child: Text(
                    "Calculate",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
