import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/providers/network_provider.dart';
import '../../../../core/route/route.dart';
import '../../../notes/presentation/providers/course_provider.dart';
import '../../../notes/presentation/providers/topic_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String userName = 'John Doe';
  String image = 'assets/images/avatar1.png';
  bool? isActivated;
  String? schoolId;
  String? level;

  @override
  // void initState() {
  //   super.initState();

  //   Future.microtask(() async {
  //     await getUser();
  //     if (schoolId != null && level != null) {
  //       await ref
  //           .read(courseNotifierProvider.notifier)
  //           .getCourses(schoolId!, level!);
  //       await ref
  //           .read(topicNotifierProvider.notifier)
  //           .getTopics(schoolId!, level!);
  //     }
  //   });
  // }

  void initState() {
    super.initState(); // Always call this first

    // Check connectivity using ref.read
    final isConnected = ref.read(connectivityProvider);

    if (isConnected) {
      Future.microtask(() async {
        await getUser();
        if (schoolId != null && level != null) {
          await ref
              .read(courseNotifierProvider.notifier)
              .getCourses(schoolId!, level!);
          await ref
              .read(topicNotifierProvider.notifier)
              .getTopics(schoolId!, level!);
        }
      });
    }
  }

  Future<void> getUser() async {
    final box = await Hive.openBox('usersBox');
    final user = box.get('users');

    if (user != null) {
      String imageUrl = user.imageUrl;
      String name = user.fullName;

      setState(() {
        image = imageUrl.isNotEmpty ? imageUrl : 'assets/images/avatar1.png';
        userName = name;
        isActivated = user.activated ?? false;
        schoolId = user.schoolId;
        level = user.level;
      });
    } else {
      setState(() {
        image = 'assets/images/avatar1.png';
        userName = 'Jone Doe';
        isActivated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: Color.fromRGBO(15, 6, 94, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.settings);
                          },
                          child: Image(
                            image: image == "" ||
                                    image.isEmpty ||
                                    image == 'assets/images/avatar1.png'
                                ? const AssetImage(
                                    'assets/images/avatar1.png',
                                  )
                                : CachedNetworkImageProvider(image),
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
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
                      height: 5,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 300,
                            height: double.infinity,
                            child: TextFormField(
                              controller: _searchController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                enabled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(15, 6, 94, 1),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Image.asset("assets/images/search.png"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Material(
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
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    onTap: () =>
                                        context.pushNamed(AppRoutes.general),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Level Courses',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                  Text(
                                    'Access full course outlines and topics.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(255, 255, 255, 1),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Past Questions',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'C.G.P.A Calculator',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
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
                        isActivated == true
                            ? InkWell(
                                onTap: () {
                                  context.push(AppRoutes.scholarship);
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
                                    color: const Color.fromRGBO(247, 0, 0, 1),
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
                                              'Scholarship',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                            ),
                                            Text(
                                              'Get a chance to earn a scholarship.',
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
                              )
                            : Container(
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
                                  color: const Color.fromRGBO(247, 0, 0, 1),
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
                                            'Scholarship',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                            ),
                                          ),
                                          Text(
                                            'Get a chance to earn a scholarship.',
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
                        const SizedBox(
                          height: 20,
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     context.push(AppRoutes.scholarship);
                        //   },
                        //   child: Container(
                        //     width: double.infinity,
                        //     height: 55,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.black.withAlpha(51),
                        //           spreadRadius: 3,
                        //           blurRadius: 3,
                        //           offset: const Offset(0.1, 0.1),
                        //         ),
                        //       ],
                        //       color: const Color.fromRGBO(247, 0, 0, 1),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(
                        //           left: 15, right: 8, top: 5, bottom: 5),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           const Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Text(
                        //                 'Special Courses',
                        //                 style: TextStyle(
                        //                   fontSize: 20,
                        //                   fontWeight: FontWeight.w900,
                        //                   color: Color.fromRGBO(
                        //                       255, 255, 255, 1),
                        //                 ),
                        //               ),
                        //               Text(
                        //                 'Accesss Special Courses',
                        //                 style: TextStyle(
                        //                   fontSize: 10,
                        //                   fontWeight: FontWeight.w700,
                        //                   color: Color.fromRGBO(
                        //                       255, 255, 255, 1),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Image.asset(
                        //             "assets/images/special.png",
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(51),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(2, 2),
                                      ),
                                      //
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isActivated == true
                                                  ? "App Update Available "
                                                  : "Activate App",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromRGBO(
                                                    15, 6, 94, 1),
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                            Text(
                                              isActivated == true
                                                  ? "Check for app update"
                                                  : "Get full app access after activation",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.underline,
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
                                isActivated == true
                                    ? InkWell(
                                        onTap: () {
                                          context.push(AppRoutes.scholarship);
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
                                                color:
                                                    Colors.black.withAlpha(51),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: Offset(2, 2),
                                              ),
                                              //
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Special Courses",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Color.fromRGBO(
                                                            15, 6, 94, 1),
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Get full app access after activation",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
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
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 43,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(51),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(2, 2),
                                            ),
                                            //
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Special Courses",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Color.fromRGBO(
                                                          15, 6, 94, 1),
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Get full app access after activation",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                      decoration: TextDecoration
                                                          .underline,
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
                                Container(
                                  width: double.infinity,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(51),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(2, 2),
                                      ),
                                      //
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Task/Refund",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                                color: Color.fromRGBO(
                                                    15, 6, 94, 1),
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                            Text(
                                              "Message us on Our sociam Media Platform",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/instagram.png",
                                            ),
                                            Image.asset(
                                              "assets/images/facebook.png",
                                            ),
                                            Image.asset(
                                              "assets/images/telegram.png",
                                            ),
                                            Image.asset(
                                              "assets/images/tiktok.png",
                                            ),
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
      ),
    );
  }
}
