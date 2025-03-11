import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/config/boxsize.dart';
import 'package:ited_study/core/config/text_style.dart.dart';
import 'package:ited_study/core/route/route.dart';
import 'package:ited_study/feature/auth/presentation/providers/logout_provide.dart';
import 'package:ited_study/feature/auth/presentation/providers/upload_image_provider.dart';
import '../../../../core/providers/network_provider.dart';
import '../providers/local/get_stored_user_provider.dart';

class SetttingsScreen extends ConsumerStatefulWidget {
  const SetttingsScreen({super.key});

  @override
  ConsumerState<SetttingsScreen> createState() => _SetttingsScreenState();
}

class _SetttingsScreenState extends ConsumerState<SetttingsScreen> {
  double cgpa = 0.00;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final isConnected = ref.watch(connectivityProvider);
      if (isConnected) {
        ref.read(storedUserNotifierProvider.notifier).getStored();
      }
    });

    getCGPA();
  }

  void getCGPA() async {
    final box = await Hive.openBox('gp');
    final cgpaTotal = box.get('cgpa');
    if (cgpaTotal != null) {
      setState(() {
        cgpa = cgpaTotal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final logOutState = ref.watch(logoutNotifierProvider);
    final uploadImageState = ref.watch(uploadImageNotifierProvider);
    final storedUserState = ref.watch(storedUserNotifierProvider);
    ref.listen<LogoutState>(
      logoutNotifierProvider,
      (previous, next) {
        if (next.status == LogoutStatus.success) {
          context.pushReplacement(AppRoutes.onboarding);
        } else if (next.status == LogoutStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error ?? 'Logout failed'),
            ),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color.fromRGBO(0, 5, 45, 1),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: logOutState.status == LogoutStatus.loading ||
              uploadImageState.status == UploadImageStatus.loading ||
              storedUserState.status == StoredUserStatus.loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : storedUserState.status == StoredUserStatus.success
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 140,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 108,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(0, 5, 45, 1),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  right: 20,
                                  bottom: 10,
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                    storedUserState.user!.level,
                                                    style: CustomTextStyles
                                                        .mediumSubtitleText),
                                                const Text("LEVEL",
                                                    style: CustomTextStyles
                                                        .levelTitle),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  storedUserState
                                                              .user!.semester ==
                                                          "null"
                                                      ? storedUserState
                                                          .user!.semester!
                                                      : "First",
                                                  style: CustomTextStyles
                                                      .mediumSubtitleText,
                                                ),
                                                Text("Semester",
                                                    style: CustomTextStyles
                                                        .levelTitle),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  cgpa.toStringAsFixed(2),
                                                  style: CustomTextStyles
                                                      .mediumSubtitleText,
                                                ),
                                                const Text("C.G.P.A",
                                                    style: CustomTextStyles
                                                        .levelTitle),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left:
                                      MediaQuery.of(context).size.width * 0.5 -
                                          70,
                                  bottom: 90,
                                  child: Text(
                                    storedUserState.user!.fullName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 30),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Container(
                            width: double.infinity,
                            height: 430,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  CustomSizeBox.mediumBox,
                                  GestureDetector(
                                    onTap: () {
                                      context.push(AppRoutes.editprofile);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/editbio.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Edit Profile",
                                                style: CustomTextStyles
                                                    .settingsText,
                                              ),
                                              Text(
                                                "Update you personal profile",
                                                style: CustomTextStyles
                                                    .textSettings,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  CustomSizeBox.box,
                                  GestureDetector(
                                    onTap: () {
                                      context.push(AppRoutes.changepassword);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/reset.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Password Reset",
                                                style: CustomTextStyles
                                                    .normalTextSetting,
                                              ),
                                              Text(
                                                "Change your password",
                                                style: CustomTextStyles
                                                    .textSettings,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  CustomSizeBox.box,
                                  GestureDetector(
                                    onTap: () {
                                      context.push(AppRoutes.activate);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/activate.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "App Activation",
                                                style: CustomTextStyles
                                                    .normalTextSetting,
                                              ),
                                              Text(
                                                "Get activated to unlock full access",
                                                style: CustomTextStyles
                                                    .textSettings,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  CustomSizeBox.box,
                                  GestureDetector(
                                    onTap: () {
                                      context.push(AppRoutes.aboutus);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/aboutus.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "About Us",
                                                style: CustomTextStyles
                                                    .normalTextSetting,
                                              ),
                                              Text(
                                                "Mission, Vision, Terms and Conditions",
                                                style: CustomTextStyles
                                                    .textSettings,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  CustomSizeBox.box,
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      0, 5, 45, 1),
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/checkmark.png",
                                                  ),
                                                  const Text(
                                                    "Alert",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: const Text(
                                                "Are you sure you want to signout?",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            logoutNotifierProvider
                                                                .notifier)
                                                        .logout();
                                                  },
                                                  child: const Text(
                                                    "Sign Out",
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 5, 45, 1),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/logout.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Log Out",
                                                style: CustomTextStyles
                                                    .normalTextSetting,
                                              ),
                                              Text(
                                                "Sign Out of your account",
                                                style: CustomTextStyles
                                                    .textSettings,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : storedUserState.status == StoredUserStatus.error
                  ? Text('Error: ${storedUserState.error}')
                  : Container(),
    );
  }
}
