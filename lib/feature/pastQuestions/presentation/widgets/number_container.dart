import 'package:flutter/material.dart';

class NumberContainer extends StatelessWidget {
  final String number;
  final Color? color;
  const NumberContainer({
    super.key,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(0, 5, 45, 1),
        ),
      ),
      child: Center(
        child: Text(number),
      ),
    );
  }
}
