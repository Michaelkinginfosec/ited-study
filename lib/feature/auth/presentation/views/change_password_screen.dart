// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ited_study/core/widgets/custom_app_bar.dart';
import 'package:ited_study/feature/auth/presentation/providers/change_password_provider.dart';

import '../../../../core/constants/boxsize.dart';
import '../../../../core/constants/text_style.dart.dart';

import '../../../../core/route/route.dart';
import '../widgets/text_field.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      ChangePasswordScreenState();
}

class ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final changePasswordState = ref.watch(changePasswordNotifierProvider);
    ref.listen<ChangePasswordState>(
      changePasswordNotifierProvider,
      (previouse, next) async {
        if (next.status == ChangePasswordStatus.success) {
          final snackBar = SnackBar(
            content: Text('Password changed successfully'),
          );
          ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
              snackBarController =
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
          await snackBarController.closed;
          context.pushReplacement(AppRoutes.login);
        } else if (next.status == ChangePasswordStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error),
            ),
          );
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSizeBox.extralBig,
                Text(
                  textAlign: TextAlign.center,
                  "Change Password",
                  style: CustomTextStyles.changePassword,
                ),
                Text(
                  "Update your password",
                  style: CustomTextStyles.mediumSubtitle,
                ),
                CustomSizeBox.extralBig,
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSizeBox.mediumBox,
                      Text(
                        "Old Password",
                        style: CustomTextStyles.mediumSubtitle,
                      ),
                      CustomSizeBox.smallBox,
                      CustomTextField(
                        obscureText: true,
                        controller: _oldPasswordController,
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
                      Text(
                        "New Password",
                        style: CustomTextStyles.mediumSubtitle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextField(
                        obscureText: true,
                        controller: _newPasswordController,
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
                      CustomSizeBox.extral,
                      changePasswordState.status == ChangePasswordStatus.loading
                          ? Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(changePasswordNotifierProvider
                                          .notifier)
                                      .changePassword(
                                        _oldPasswordController.text,
                                        _newPasswordController.text,
                                      );
                                  _oldPasswordController.clear();
                                  _newPasswordController.clear();
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
                                  "Change Password",
                                  style: CustomTextStyles.buttonText,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
