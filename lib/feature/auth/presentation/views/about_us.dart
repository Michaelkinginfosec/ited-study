// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ited_study/core/constants/boxsize.dart';
import 'package:ited_study/core/constants/text_style.dart.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 4, 45, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Contact Us",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About Us",
                style: CustomTextStyles.bold,
              ),
              Text(
                "Get to know more about ITed Education Software",
                style: CustomTextStyles.smallBody,
              ),
              CustomSizeBox.mediumBox,
              Text(
                "The App",

                // style: CustomTextStyles.normal,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
              Text(
                "ITed Educational Software is designed to revolutionize the way students learn by offering a comprehensive suite of educational tools. Our app provides interactive lessons that make learning more engaging, access to a vast library of e-books for in-depth study, and quizzes to help evaluate and reinforce knowledge. We harness the power of adaptive learning to personalize each student’s educational journey, offering tailored recommendations and tracking progress to ensure continuous improvement. With ITed, education is not just a process but an enjoyable and enriching experience.",
                style: CustomTextStyles.normal,
              ),
              CustomSizeBox.mediumBox,
              Text(
                "Mision",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
              Text(
                "Our mission is to offer a personalized and engaging learning experience that adapts to each student’s needs. Through innovative tools and technology, we strive to inspire a lifelong love of learning and support academic success.",
                style: CustomTextStyles.normal,
              ),
              CustomSizeBox.mediumBox,
              Text(
                "Vision",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
              Text(
                "We aim to empower learners globally by making education personalized, accessible, and enjoyable. Our vision is to lead in educational innovation, ensuring every student has the opportunity to excel and grow.",
                style: CustomTextStyles.normal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
