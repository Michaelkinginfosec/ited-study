// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/feature/auth/presentation/providers/reset_password_provider.dart';

import '../../../../core/config/style/boxsize.dart';
import '../../../../core/config/style/text_style.dart.dart';

import '../providers/resend_otp_provider.dart';
import '../widgets/text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _resetEmailController = TextEditingController();
  final TextEditingController _resetOTPController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    final sendOTP = ref.watch(resendOTPNotifierProvider);
    final resetPassword = ref.watch(resetPasswordNotifierProvider);
    ref.listen<ResendOTPState>(
      resendOTPNotifierProvider,
      (previous, next) {
        if (next.status == ResendOTPStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message ?? 'OTP Sent successfully'),
            ),
          );
        } else if (next.status == ResendOTPStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error ?? "Failed to send OTP"),
            ),
          );
        }
      },
    );

    ref.listen<ResetPasswordState>(
      resetPasswordNotifierProvider,
      (previous, next) {
        if (next.status == ResetPasswordStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message ?? 'Password Reset Successfully'),
            ),
          );
        } else if (next.status == ResetPasswordStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error ?? "Failed to Reset Password"),
            ),
          );
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            CustomSizeBox.extralBig,
            Text(
              "Reset Password",
              style: CustomTextStyles.largeBoldTitle,
            ),
            Text(
              "Enter your to receive a reset password token",
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
                    obscureText: false,
                    controller: _resetEmailController,
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
                  sendOTP.status == ResendOTPStatus.loading
                      ? Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(resendOTPNotifierProvider.notifier)
                                  .resendOTPCode(
                                    _resetEmailController.text.trim(),
                                  );
                              _resetEmailController.clear();
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
                              "Send Email",
                              style: CustomTextStyles.buttonText,
                            ),
                          ),
                        ),
                  CustomSizeBox.largeBox,
                  Text(
                    "Input OTP",
                    style: CustomTextStyles.mediumSubtitle,
                  ),
                  CustomSizeBox.littleBox,
                  CustomTextField(
                    obscureText: false,
                    controller: _resetOTPController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter Reset OTP';
                      }
                      return null;
                    },
                  ),
                  CustomSizeBox.mediumBox,
                  Text(
                    "Password",
                    style: CustomTextStyles.mediumSubtitle,
                  ),
                  CustomSizeBox.littleBox,
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
                    obscureText: isVisible,
                    controller: _newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter new password';
                      }
                      return null;
                    },
                  ),
                  CustomSizeBox.mediumBox,
                  resetPassword.status == ResetPasswordStatus.loading
                      ? Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .read(
                                        resetPasswordNotifierProvider.notifier)
                                    .resetPassword(
                                      _resetOTPController.text.trim(),
                                      _newPasswordController.text.trim(),
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
                              "Reset Password",
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
    );
  }
}
