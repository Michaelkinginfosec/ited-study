import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecondScreen extends ConsumerStatefulWidget {
  const SecondScreen({super.key});

  @override
  ConsumerState<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends ConsumerState<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/second_screen.png"),
          SizedBox(height: 30),
          Text(
            "Welcome to ITed!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "Welcome to your gateway of knowledge—",
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
              "let's make every moment count!" ",",
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
