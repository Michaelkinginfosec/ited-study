import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ited_study/core/constants/boxsize.dart';
import 'package:ited_study/core/constants/text_style.dart.dart';
import 'package:ited_study/core/route/route.dart';
import 'package:ited_study/feature/auth/presentation/providers/logout_provide.dart';
import 'package:ited_study/feature/auth/presentation/providers/upload_image_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SetttingsScreen extends ConsumerStatefulWidget {
  const SetttingsScreen({super.key});

  @override
  ConsumerState<SetttingsScreen> createState() => _SetttingsScreenState();
}

class _SetttingsScreenState extends ConsumerState<SetttingsScreen> {
  String userName = "Jone Doe";
  String image = 'assets/images/avatar.jpg';
  String level = '';
  double cgpa = 0.00;
  Uint8List? imageFile;
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    getUser();
    getCGPA();
  }

  void getUser() async {
    final box = Hive.box('usersBox');
    final user = box.get('users');

    if (user != null) {
      final name = user.fullName;
      final userLevel = user.level;
      image = user.imageUrl ?? 'assets/images/avatar.jpg';
      setState(() {
        userName = name;
        level = userLevel;
      });
    } else {
      setState(() {
        userName = "Jone Doe";
        image = 'assets/images/avatar.jpg';
      });
    }
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

  void pickImage() async {
    var status = await Permission.photos.request();

    if (status.isGranted) {
      try {
        var box = Hive.box('sessionBox');
        var userId = box.get('userId');
        var token = box.get('token');

        if (userId == null) {
          throw Exception('User not found');
        }
        if (token == null) {
          throw Exception('Unauthorized');
        }

        final imagePicker = ImagePicker();
        final pickedFile =
            await imagePicker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          final imageBytes = await pickedFile.readAsBytes();
          setState(() {
            imageFile = imageBytes;
          });

          final url = await ref
              .read(uploadImageNotifierProvider.notifier)
              .uploadImage(imageBytes);

          setState(() {
            imageUrl = url;
            image = imageUrl!;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error picking image: $e")),
        );
      }
    } else if (status.isPermanentlyDenied) {
      // If permission is permanently denied, prompt to open app settings
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Permission denied. Please enable it from settings."),
          action: SnackBarAction(
            label: "Settings",
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission denied")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final logOutState = ref.watch(logoutNotifierProvider);
    final uploadImageState = ref.watch(uploadImageNotifierProvider);
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
    ref.listen<UploadImageState>(
      uploadImageNotifierProvider,
      (previous, next) {
        if (next.status == UploadImageStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message ?? "Image upload success"),
            ),
          );
        } else if (next.status == UploadImageStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error ?? "Image Uploaod failed"),
            ),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: CustomTextStyles.normalTextSetting2,
        ),
      ),
      body: logOutState.status == LogoutStatus.loading ||
              uploadImageState.status == UploadImageStatus.loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(0, 5, 45, 1),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 130,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: image == "" ||
                                          image.isEmpty ||
                                          image == 'assets/images/avatar.jpg'
                                      ? const AssetImage(
                                          'assets/images/avatar.jpg',
                                        )
                                      : CachedNetworkImageProvider(image),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: -70,
                            left: 10,
                            child: GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CustomSizeBox.smallBox,
                  Text(
                    userName,
                    style: CustomTextStyles.nameTitle,
                  ),
                  CustomSizeBox.mediumBox,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  level,
                                  style: CustomTextStyles.mediumSubtitleText,
                                ),
                                const Text("LEVEL",
                                    style: CustomTextStyles.levelTitle),
                              ],
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "60%",
                                  style: CustomTextStyles.mediumSubtitleText,
                                ),
                                Text("course completion",
                                    style: CustomTextStyles.levelTitle),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  cgpa.toStringAsFixed(2),
                                  style: CustomTextStyles.mediumSubtitleText,
                                ),
                                const Text("C.G.P.A",
                                    style: CustomTextStyles.levelTitle),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Edit Profile",
                                      style: CustomTextStyles.normalTextSetting,
                                    ),
                                    Text(
                                      "Update you personal profile",
                                      style: CustomTextStyles.textSettings,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Password Reset",
                                      style: CustomTextStyles.normalTextSetting,
                                    ),
                                    Text(
                                      "Change your password",
                                      style: CustomTextStyles.textSettings,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "App Activation",
                                      style: CustomTextStyles.normalTextSetting,
                                    ),
                                    Text(
                                      "Get activated to unlock full access",
                                      style: CustomTextStyles.textSettings,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "About Us",
                                      style: CustomTextStyles.normalTextSetting,
                                    ),
                                    Text(
                                      "Mission, Vision, Terms and Conditions",
                                      style: CustomTextStyles.textSettings,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomSizeBox.box,
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        const Color.fromRGBO(0, 5, 45, 1),
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
                                            fontWeight: FontWeight.w700,
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
                                        MainAxisAlignment.spaceBetween,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(logoutNotifierProvider
                                                  .notifier)
                                              .logout();
                                        },
                                        child: const Text(
                                          "Sign Out",
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 5, 45, 1),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Log Out",
                                      style: CustomTextStyles.normalTextSetting,
                                    ),
                                    Text(
                                      "Sign Out of your account",
                                      style: CustomTextStyles.textSettings,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
