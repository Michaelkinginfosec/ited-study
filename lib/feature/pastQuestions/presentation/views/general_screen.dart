// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ited_study/core/constants/boxsize.dart';
import 'package:ited_study/core/route/route.dart';
import 'package:ited_study/feature/pastQuestions/presentation/widgets/past_question_container.dart';

import '../../../../core/constants/text_style.dart.dart';

class GeneralScreen extends StatelessWidget {
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Past Questions",
          style: CustomTextStyles.normalTextSetting2,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.push(AppRoutes.testquestion);
              },
              child: PastQuestionContainer(
                title: "Test Past Questions",
              ),
            ),
            CustomSizeBox.mediumBox,
            GestureDetector(
              onTap: () {
                context.push(AppRoutes.examquestion);
              },
              child: PastQuestionContainer(
                title: "Exam Past Questions",
              ),
            ),
            CustomSizeBox.mediumBox,
            GestureDetector(
              onTap: () {
                context.push(AppRoutes.cbt);
              },
              child: PastQuestionContainer(
                title: "CBT Mode",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
