// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../../core/constants/boxsize.dart';
import '../../../../core/constants/text_style.dart.dart';

import '../widgets/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _resetEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
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
              "Enter your to receive a reset password link",
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
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
