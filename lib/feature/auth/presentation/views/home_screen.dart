// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/route/route.dart';
import 'package:ited_study/feature/notes/presentation/providers/topic_provider.dart';

import '../../../notes/presentation/providers/course_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String userName = 'John Doe';
  String image = 'assets/images/avatar.jpg';

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInToLinear,
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 5, 45, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: <Widget>[
              Text("Hello"),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        ref.read(courseNotifierProvider.notifier).getCourses();
        ref.read(topicNotifierProvider.notifier).getTopics();
      },
    );

    getUser();
  }

  void getUser() async {
    final box = await Hive.openBox('usersBox');
    final user = box.get('users');
    if (user != null) {
      String imageUrl = user.imageUrl;
      String name = user.fullName;

      setState(() {
        image = imageUrl.isNotEmpty ? imageUrl : 'assets/images/avatar.jpg';
        userName = name;
      });
    } else {
      setState(() {
        image = 'assets/images/avatar.jpg';
        userName = 'Jone Doe';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.settings);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            image: image != 'assets/images/avatar.jpg'
                                ? NetworkImage(image)
                                : AssetImage('assets/images/avatar.jpg')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 182,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/learn.png"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    context.pushNamed(AppRoutes.course);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0.1, 0.1),
                        ),
                      ],
                      color: Color.fromRGBO(22, 5, 209, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Level Courses',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Text(
                                  'Get full access to all you course outline and well explained topics',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Image.asset(
                              "assets/images/notepad.png",
                              height: 75,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    context.push(
                      AppRoutes.general,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0.1, 0.1),
                        ),
                      ],
                      color: Color.fromRGBO(247, 0, 0, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Past Questions',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Get access to updated past questions',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/images/questions.png",
                            height: 75,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    context.push(AppRoutes.cgpascreen);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0.1, 0.1),
                        ),
                      ],
                      color: Color.fromRGBO(9, 108, 19, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'C.G.P.A Calculator',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'calculate your CGPA with ease',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/images/calculator.png",
                            height: 75,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   width: double.infinity,
                //   height: 80,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(25),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.2),
                //         spreadRadius: 3,
                //         blurRadius: 3,
                //         offset: Offset(0.1, 0.1),
                //       ),
                //     ],
                //     color: Color.fromRGBO(134, 150, 11, 1),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 15, right: 8),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             const SizedBox(
                //               height: 8,
                //             ),
                //             Text(
                //               'Special Courses',
                //               style: TextStyle(
                //                 fontSize: 25,
                //                 fontWeight: FontWeight.bold,
                //                 color: Color.fromRGBO(255, 255, 255, 1),
                //               ),
                //             ),
                //             const SizedBox(
                //               height: 5,
                //             ),
                //             Text(
                //               'Get your course from your favourite lecturers',
                //               style: TextStyle(
                //                 fontSize: 10,
                //                 fontWeight: FontWeight.bold,
                //                 color: Color.fromRGBO(255, 255, 255, 1),
                //               ),
                //             ),
                //           ],
                //         ),
                //         Image.asset(
                //           "assets/images/elearning.png",
                //           height: 75,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    context.push(AppRoutes.scholarship);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0.1, 0.1),
                        ),
                      ],
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Scholarship',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Stand a chance to become one of our scholarship beneficials',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/images/scholarship.png",
                            height: 75,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
