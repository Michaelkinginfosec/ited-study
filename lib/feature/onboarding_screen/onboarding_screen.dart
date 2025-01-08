// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ited_study/core/route/route.dart';
import 'package:ited_study/feature/onboarding_screen/first_screen.dart';
import 'package:ited_study/feature/onboarding_screen/second_screen.dart';
import 'package:ited_study/feature/onboarding_screen/third_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  FirstScreen(),
                  SecondScreen(),
                  ThirdScreen(),
                ],
              ),
            ),
            _buildNextButton(context),
            SizedBox(height: 20),
            _buildPageIndicator(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, (int index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          height: 10.0,
          width: _currentPage == index ? 24.0 : 12.0,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_currentPage < 2) {
          _pageController.animateToPage(
            _currentPage + 1,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        } else {
          context.push(AppRoutes.school);
        }
      },
      child: Container(
        width: 150,
        height: 40,
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 5, 45, 1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _currentPage == 2 ? 'Get Started' : 'Next',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset("assets/images/arrow_next.png")
            ],
          ),
        ),
      ),
    );
  }
}
