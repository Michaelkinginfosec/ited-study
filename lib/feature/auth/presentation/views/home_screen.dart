import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/utils/url_laucher.dart';
import 'package:ited_study/feature/notes/presentation/providers/remote/course_provider.dart';
import 'package:ited_study/feature/notes/presentation/providers/remote/topic_provider.dart';

import '../../../../core/providers/network_provider.dart';
import '../../../../core/config/routes/route.dart';
import '../providers/local/get_stored_user_provider.dart';

import '../widgets/flash_cards.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? level;
  String? schoolId;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await getUser();

      final isConnected = ref.read(connectivityProvider);

      if (isConnected) {
        ref.read(storedUserNotifierProvider.notifier).getStored();

        if (schoolId != null && level != null) {
          ref.read(topicNotifierProvider.notifier).getTopics(schoolId!, level!);
          ref
              .read(courseNotifierProvider.notifier)
              .getCourses(schoolId!, level!);
        }
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_currentPage < 6) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        _currentPage = 0;
        _pageController.jumpToPage(_currentPage);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getUser() async {
    final box = await Hive.openBox('usersBox');
    final schoolBox = await Hive.openBox("school");
    final school = schoolBox.get("schoolId");
    final user = box.get('users');

    if (user != null && school != null) {
      setState(() {
        level = user.level;
        schoolId = school;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storedUserState = ref.watch(storedUserNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: storedUserState.status == StoredUserStatus.loading
          ? CircularProgressIndicator()
          : storedUserState.status == StoredUserStatus.success
              ? Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 230,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(15, 6, 94, 1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  context.push(AppRoutes.settings);
                                },
                                child: Text(
                                  storedUserState.user!.fullName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "ITed E-Study",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Best pathway to academic excellence",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Center(
                                    child: Text(
                                      storedUserState.user!.semester == null
                                          ? "${storedUserState.user!.semester} SEMESTER"
                                          : "FIRST SEMESTER",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        fontFamily: 'Karla',
                                        color: Color.fromRGBO(0, 5, 45, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 140,
                      child: PageView(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            FlashCards(),
                            FlashCards(),
                            FlashCards(),
                            FlashCards(),
                            FlashCards(),
                            FlashCards(),
                            FlashCards(),
                          ]),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  context.pushNamed(AppRoutes.course);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(51),
                                        spreadRadius: 3,
                                        blurRadius: 3,
                                        offset: const Offset(0.1, 0.1),
                                      ),
                                    ],
                                    color: const Color.fromRGBO(15, 6, 94, 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 8, top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Level Courses',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                            ),
                                            Text(
                                              'Access full course outlines and topics.',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Image.asset(
                                          "assets/images/notepad.png",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
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
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(51),
                                        spreadRadius: 3,
                                        blurRadius: 3,
                                        offset: const Offset(0.1, 0.1),
                                      ),
                                    ],
                                    color: const Color.fromRGBO(15, 6, 94, 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 8, top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Past Questions',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                            ),
                                            Text(
                                              'Get access to updated past questions',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Image.asset(
                                          "assets/images/questions.png",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  context.push(AppRoutes.cgpascreen);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(51),
                                        spreadRadius: 3,
                                        blurRadius: 3,
                                        offset: const Offset(0.1, 0.1),
                                      ),
                                    ],
                                    color: const Color.fromRGBO(15, 6, 94, 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 8, top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'C.G.P.A Calculator',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                            ),
                                            Text(
                                              'calculate your CGPA with ease',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Image.asset(
                                          "assets/images/calculator.png",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  // isActivated == true
                                  //     ? InkWell(
                                  //         onTap: () {
                                  //           context.push(AppRoutes.scholarship);
                                  //         },
                                  //         child: Container(
                                  //           width: double.infinity,
                                  //           height: 55,
                                  //           decoration: BoxDecoration(
                                  //             borderRadius: BorderRadius.circular(10),
                                  //             boxShadow: [
                                  //               BoxShadow(
                                  //                 color: Colors.black.withAlpha(51),
                                  //                 spreadRadius: 3,
                                  //                 blurRadius: 3,
                                  //                 offset: const Offset(0.1, 0.1),
                                  //               ),
                                  //             ],
                                  //             color: const Color.fromRGBO(247, 0, 0, 1),
                                  //           ),
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 15, right: 8, top: 5, bottom: 5),
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.spaceBetween,
                                  //               children: [
                                  //                 const Column(
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment.start,
                                  //                   children: [
                                  //                     Text(
                                  //                       'Scholarship',
                                  //                       style: TextStyle(
                                  //                         fontSize: 20,
                                  //                         fontWeight: FontWeight.w900,
                                  //                         color: Color.fromRGBO(
                                  //                             255, 255, 255, 1),
                                  //                       ),
                                  //                     ),
                                  //                     Text(
                                  //                       'Get a chance to earn a scholarship.',
                                  //                       style: TextStyle(
                                  //                         fontSize: 10,
                                  //                         fontWeight: FontWeight.w700,
                                  //                         color: Color.fromRGBO(
                                  //                             255, 255, 255, 1),
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //                 Image.asset(
                                  //                   "assets/images/scholarship.png",
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       )
                                  // :
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Column(
                                              children: [
                                                Icon(
                                                    Icons.rocket_launch_rounded,
                                                    size: 60,
                                                    color: Colors.blueAccent),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Coming Soon!",
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: Text(
                                              "We're working hard to bring you special tech courses. Stay tuned for updates!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  "Got it!",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(51),
                                            spreadRadius: 3,
                                            blurRadius: 3,
                                            offset: const Offset(0.1, 0.1),
                                          ),
                                        ],
                                        color:
                                            const Color.fromRGBO(247, 0, 0, 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 8,
                                            top: 5,
                                            bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Special Courses',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                  ),
                                                ),
                                                Text(
                                                  'get full app access after activation',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Image.asset(
                                              "assets/images/scholarship.png",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 203,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(51),
                                          spreadRadius: 3,
                                          blurRadius: 3,
                                          offset: const Offset(0.1, 0.1),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withAlpha(51),
                                          spreadRadius: 3,
                                          blurRadius: 3,
                                          offset: const Offset(-0.1, -0.1),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 10,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          storedUserState.user!.activated ==
                                                  false
                                              ? GestureDetector(
                                                  onTap: () {
                                                    context.push(
                                                        AppRoutes.activate);
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 43,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withAlpha(51),
                                                          spreadRadius: 1,
                                                          blurRadius: 1,
                                                          offset: Offset(2, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                storedUserState
                                                                            .user!
                                                                            .activated ==
                                                                        true
                                                                    ? "App Update Available "
                                                                    : "Activate App",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          15,
                                                                          6,
                                                                          94,
                                                                          1),
                                                                ),
                                                              ),
                                                              Text(
                                                                storedUserState
                                                                            .user!
                                                                            .activated ==
                                                                        true
                                                                    ? "Check for app update"
                                                                    : "Get full app access after activation",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Image.asset(
                                                            "assets/images/app_update.png",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  height: 43,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withAlpha(51),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: Offset(2, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              storedUserState
                                                                          .user!
                                                                          .activated ==
                                                                      true
                                                                  ? "App Update Available "
                                                                  : "Activate App",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Inter",
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        15,
                                                                        6,
                                                                        94,
                                                                        1),
                                                              ),
                                                            ),
                                                            Text(
                                                              storedUserState
                                                                          .user!
                                                                          .activated ==
                                                                      true
                                                                  ? "Check for app update"
                                                                  : "Get full app access after activation",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    "Inter",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Image.asset(
                                                          "assets/images/app_update.png",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          // isActivated == true
                                          //     ? InkWell(
                                          //         onTap: () {
                                          //           context.push(AppRoutes.scholarship);
                                          //         },
                                          //         child: Container(
                                          //           width: double.infinity,
                                          //           height: 43,
                                          //           decoration: BoxDecoration(
                                          //             borderRadius:
                                          //                 BorderRadius.circular(10),
                                          //             color: Colors.white,
                                          //             boxShadow: [
                                          //               BoxShadow(
                                          //                 color:
                                          //                     Colors.black.withAlpha(51),
                                          //                 spreadRadius: 1,
                                          //                 blurRadius: 1,
                                          //                 offset: Offset(2, 2),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //           child: Padding(
                                          //             padding: const EdgeInsets.symmetric(
                                          //               horizontal: 10,
                                          //             ),
                                          //             child: Row(
                                          //               mainAxisAlignment:
                                          //                   MainAxisAlignment
                                          //                       .spaceBetween,
                                          //               children: [
                                          //                 Column(
                                          //                   crossAxisAlignment:
                                          //                       CrossAxisAlignment.start,
                                          //                   children: [
                                          //                     Text(
                                          //                       "Scholarship",
                                          //                       style: TextStyle(
                                          //                         fontSize: 15,
                                          //                         fontWeight:
                                          //                             FontWeight.w900,
                                          //                         color: Color.fromRGBO(
                                          //                             15, 6, 94, 1),
                                          //                       ),
                                          //                     ),
                                          //                     Text(
                                          //                       'Get a chance to earn a scholarship.',
                                          //                       style: TextStyle(
                                          //                         fontSize: 10,
                                          //                         fontFamily: "Inter",
                                          //                         fontWeight:
                                          //                             FontWeight.w700,
                                          //                         color: Colors.black,
                                          //                       ),
                                          //                     ),
                                          //                   ],
                                          //                 ),
                                          //                 Image.asset(
                                          //                   "assets/images/campus.png",
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       )
                                          //     :
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    title: Column(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .school_rounded,
                                                            size: 60,
                                                            color:
                                                                Colors.green),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          "Scholarships Coming Soon!",
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                    content: Text(
                                                      "Exciting scholarship opportunities are on the way! Stay tuned for updates.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          "Got it!",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 43,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(51),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(2, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Scholarship",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily: "Inter",
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color:
                                                                Color.fromRGBO(
                                                                    15,
                                                                    6,
                                                                    94,
                                                                    1),
                                                          ),
                                                        ),
                                                        Text(
                                                          'Get a chance to earn a scholarship.',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontFamily: "Inter",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Image.asset(
                                                      "assets/images/campus.png",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 43,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withAlpha(51),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(2, 2),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Task/Refund",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontFamily: "Inter",
                                                          color: Color.fromRGBO(
                                                              15, 6, 94, 1),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Message us on Our sociam Media Platform",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: UrlLaucher()
                                                            .openInstagram,
                                                        child: Image.asset(
                                                          "assets/images/instagram.png",
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: UrlLaucher()
                                                            .openFacebook,
                                                        child: Image.asset(
                                                          "assets/images/facebook.png",
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: UrlLaucher()
                                                            .openTelegram,
                                                        child: Image.asset(
                                                          "assets/images/telegram.png",
                                                        ),
                                                      ),
                                                      // Image.asset(
                                                      //   "assets/images/tiktok.png",
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : storedUserState.status == StoredUserStatus.error
                  ? Center(
                      child: Text('Error: ${storedUserState.error}'),
                    )
                  : Center(
                      child: Container(),
                    ),
    );
  }
}
