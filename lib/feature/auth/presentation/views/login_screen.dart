// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ited_study/core/config/style/boxsize.dart';
import 'package:ited_study/core/config/style/text_style.dart.dart';
import 'package:ited_study/core/config/routes/route.dart';
import 'package:ited_study/feature/auth/presentation/providers/login_provider.dart';
import 'package:ited_study/feature/auth/presentation/widgets/text_field.dart';
import '../providers/resend_otp_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;
  bool isObscure = false;
  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);
    ref.listen<LoginState>(
      loginNotifierProvider,
      (previous, next) async {
        if (next.status == LoginStatus.success) {
          final snackBar = SnackBar(
            content: Text(next.message ?? 'Login Success'),
          );
          ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
              snackBarController =
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

          await snackBarController.closed;

          context.pushReplacement(
            AppRoutes.home,
          );
        } else if (next.status == LoginStatus.error) {
          String errorMessage = next.error?.toString() ?? "Login Failed";

          if (errorMessage.contains('User is not verified')) {
            final snackBar = SnackBar(
              backgroundColor: CustomTextStyles.loginsignupButtonColor,
              content: Text(
                'Please verify your email to login',
                style: CustomTextStyles.mediumSubtitle,
              ),
            );
            ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
                snackBarController =
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
            await snackBarController.closed;

            ref.read(resendOTPNotifierProvider.notifier).resendOTPCode(
                  _emailController.text.trim(),
                );
            context.push(
              AppRoutes.verification,
              extra: _emailController.text.trim(),
            );
          } else if (errorMessage.contains('Invalid Credentials')) {
            final snackBar = SnackBar(
              content: Text('Invalid Credentials'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            final snackBar = SnackBar(content: Text(errorMessage));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomSizeBox.extralBig,
                Text(
                  "Log  In",
                  style: CustomTextStyles.bold,
                ),
                Text(
                  "Enter your details to log in",
                  style: CustomTextStyles.mediumSubtitle,
                ),
                CustomSizeBox.extralBig,
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: CustomTextStyles.mediumSubtitle,
                      ),
                      CustomSizeBox.littleBox,
                      CustomTextField(
                        obscureText: isObscure,
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
                        "Password",
                        style: CustomTextStyles.mediumSubtitle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextField(
                        suffix: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: isVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                        ),
                        obscureText: isVisible ? false : true,
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
                      CustomSizeBox.littleBox,
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.forgotpassword);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: CustomTextStyles.littleBody,
                          ),
                        ),
                      ),
                      CustomSizeBox.mediumBox,
                      loginState.status == LoginStatus.loading
                          ? Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ref
                                        .read(loginNotifierProvider.notifier)
                                        .login(
                                          _emailController.text
                                              .toLowerCase()
                                              .trim(),
                                          _passwordController.text.trim(),
                                        );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      CustomTextStyles.loginsignupButtonColor,
                                  minimumSize: Size(228, 41),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Log In",
                                  style: CustomTextStyles.buttonText,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                CustomSizeBox.smallBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: CustomTextStyles.smallBody,
                    ),
                    CustomSizeBox.tinyBox,
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.school);
                      },
                      child: Text(
                        "Sign Up",
                        style: CustomTextStyles.tinyBody,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }
}
