// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ited_study/core/constants/boxsize.dart';

import '../../../../core/constants/text_style.dart.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Cyber Security",
              style: CustomTextStyles.mediumSubtitleText,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 75),
            child: Container(
              width: 91,
              height: 24,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 5, 45, 1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  "submit",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Color.fromRGBO(0, 45, 5, 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/images/watch.png'),
                    Center(
                      child: Text(
                        "58:33",
                        style: CustomTextStyles.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomSizeBox.mediumBox,
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(1.0, 1.0),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
