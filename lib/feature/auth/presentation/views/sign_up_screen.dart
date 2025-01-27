// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/core/constants/text_style.dart.dart';
import 'package:ited_study/core/widgets/custom_app_bar.dart';
import 'package:ited_study/feature/auth/data/models/users.dart';
import 'package:ited_study/feature/auth/presentation/widgets/text_field.dart';

import '../../../../core/constants/boxsize.dart';
import '../../../../core/route/route.dart';
import '../providers/sign_up_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final String school;
  const SignUpScreen({
    super.key,
    required this.school,
  });

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  String? selectedLevel;
  List<String> level = ['100', '200', '300', '400', '500', '600'];

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpNotifierProvider);

    ref.listen<SignUpState>(signUpNotifierProvider, (previous, next) {
      if (next.status == SignUpStatus.success) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(next.message ?? 'Sign up successful!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                    context.pushReplacement(
                      AppRoutes.verification,
                      extra: _emailController.text.trim(),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else if (next.status == SignUpStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? 'Sign up failed')),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text(
              "Sign Up",
              style: CustomTextStyles.bold,
            ),
            Text(
              "Enter your details to sign up",
              style: CustomTextStyles.mediumSubtitle,
            ),
            CustomSizeBox.mediumBox,
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Full Name",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.littleBox,
                    CustomTextField(
                      obscureText: false,
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    CustomSizeBox.mediumBox,
                    Text(
                      "Email",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.smallBox,
                    CustomTextField(
                      obscureText: false,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    CustomSizeBox.mediumBox,
                    Text(
                      "Department",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.smallBox,
                    CustomTextField(
                      obscureText: false,
                      controller: _departmentController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your department';
                        }
                        return null;
                      },
                    ),
                    CustomSizeBox.mediumBox,
                    Text(
                      "Level",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.smallBox,
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(3),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: CustomTextStyles.textFieldColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: CustomTextStyles.textFieldColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: CustomTextStyles.textFieldColor,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: CustomTextStyles.textFieldColor,
                          ),
                        ),
                        enabled: true,
                        fillColor: CustomTextStyles.textFieldColor,
                        filled: true,
                      ),
                      value: selectedLevel,
                      items: level.map((String schoolName) {
                        return DropdownMenuItem<String>(
                          value: schoolName,
                          child: Text(schoolName),
                        );
                      }).toList(),
                      onChanged: (String? newLevel) async {
                        setState(() {
                          selectedLevel = newLevel;
                        });
                      },
                    ),
                    CustomSizeBox.mediumBox,
                    Text(
                      "Password",
                      style: CustomTextStyles.mediumSubtitle,
                    ),
                    CustomSizeBox.smallBox,
                    CustomTextField(
                      obscureText: true,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    CustomSizeBox.mediumBox,
                    const SizedBox(height: 20),
                    signUpState.status == SignUpStatus.loading
                        ? Center(
                            child: const CircularProgressIndicator.adaptive())
                        : Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    CustomTextStyles.loginsignupButtonColor,
                                minimumSize: Size(249, 33),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  var box = Hive.box('school');
                                  final schoolId = box.get('schoolId');
                                  final user = Users(
                                    verified: false,
                                    fullName: _fullNameController.text,
                                    email: _emailController.text,
                                    department: _departmentController.text,
                                    level: selectedLevel!,
                                    password: _passwordController.text,
                                    schoolId: schoolId,
                                    imageUrl: '',
                                    activated: false,
                                  );
                                  ref
                                      .read(signUpNotifierProvider.notifier)
                                      .signUp(user);
                                }
                              },
                              child: const Text(
                                'Finish',
                                style: CustomTextStyles.buttonText,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            CustomSizeBox.smallBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: CustomTextStyles.firsttinyBody,
                ),
                CustomSizeBox.tinyBox,
                InkWell(
                  onTap: () {
                    context.push(AppRoutes.login);
                  },
                  child: Text(
                    "Sign in",
                    style: CustomTextStyles.secondtinyBody,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    _levelController.dispose();
    super.dispose();
  }
}
