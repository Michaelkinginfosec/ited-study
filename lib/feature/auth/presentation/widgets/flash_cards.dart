import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/route/route.dart';

class FlashCards extends StatelessWidget {
  const FlashCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 141,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.white10,
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(10.0, 10.0),
            ),
            BoxShadow(
              color: Colors.white10,
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(-10.0, -10.0),
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Flash Cards",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color.fromRGBO(15, 6, 94, 1),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed(AppRoutes.general),
                    child: Text(
                      "Take more >",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(15, 6, 94, 1),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  "What is the chemical symbol for water?",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color.fromRGBO(15, 6, 94, 1),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                height: 17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(217, 217, 217, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text("A)"),
                      SizedBox(
                        width: 15,
                      ),
                      Text("H₂O"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 300,
                height: 17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(217, 217, 217, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text("B)"),
                      SizedBox(
                        width: 20,
                      ),
                      Text("CO₂"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
