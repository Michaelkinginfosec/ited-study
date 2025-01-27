// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/auth/presentation/views/home_screen.dart';
import 'package:ited_study/feature/auth/presentation/views/settings_screen.dart';
import 'package:ited_study/feature/notes/presentation/views/course_screen.dart';

import '../../../../core/widgets/custom_navigation_item.dart';

class NavScreen extends ConsumerStatefulWidget {
  const NavScreen({super.key});

  @override
  ConsumerState<NavScreen> createState() => _NavScreenState();
}

bool? isActivated;

class _NavScreenState extends ConsumerState<NavScreen> {
  @override
  void initState() {
    super.initState();

    getUser();
  }

  void getUser() async {
    final box = await Hive.openBox('usersBox');
    final user = box.get('users');
    if (user != null) {
      setState(() {
        isActivated = user.activated ?? false;
      });
    } else {
      setState(() {
        isActivated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);
    List<Widget> screens = [
      HomeScreen(),
      CourseScreen(),
      SetttingsScreen(),
      SetttingsScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[currentIndex],
      bottomNavigationBar: isActivated == false
          ? Container(
              width: double.infinity,
              height: 40,
              color: Colors.white,
            )
          // ? Padding(
          //     padding: const EdgeInsets.only(left: 20, right: 20, bottom: 60),
          //     child: Container(
          //       width: double.infinity,
          //       height: 40,
          //       decoration: BoxDecoration(
          //         color: Color.fromARGB(139, 168, 170, 142),
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Center(
          //         child: Text(
          //           "Activate App",
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //   )
          : Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
                left: 40,
                right: 40,
              ),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(217, 217, 217, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomNavigationItem(
                        index: 0,
                        currentIndex: currentIndex,
                        icon: "assets/images/home.png",
                      ),
                      CustomNavigationItem(
                        index: 1,
                        currentIndex: currentIndex,
                        icon: "assets/images/b_ooks.png",
                      ),
                      CustomNavigationItem(
                        index: 2,
                        currentIndex: currentIndex,
                        icon: "assets/images/dyna.png",
                      ),
                      CustomNavigationItem(
                        index: 3,
                        currentIndex: currentIndex,
                        icon: "assets/images/setting.png",
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
