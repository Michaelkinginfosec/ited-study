import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThirdScreen extends ConsumerStatefulWidget {
  const ThirdScreen({super.key});

  @override
  ConsumerState<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends ConsumerState<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/third_screen.png"),
          SizedBox(height: 30),
          Text(
            "Congrats!!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "Sit back, relax, and get ready to learn. You are just moments away from setting up your personalized course.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "every lesson is a step closer to your dreams!",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
