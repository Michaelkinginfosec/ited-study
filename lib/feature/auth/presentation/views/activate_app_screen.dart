// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/widgets/custom_app_bar.dart';

import '../../../../core/constants/boxsize.dart';
import '../../../../core/constants/text_style.dart.dart';
import '../widgets/text_field.dart';

class ActivateAppScreen extends ConsumerStatefulWidget {
  const ActivateAppScreen({super.key});

  @override
  ConsumerState<ActivateAppScreen> createState() => ActivateAppScreenState();
}

class ActivateAppScreenState extends ConsumerState<ActivateAppScreen> {
  final TextEditingController _activationCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Activate App",
              style: CustomTextStyles.boldTitle,
            ),
            Text(
              'Access full app features',
              style: CustomTextStyles.smallBody,
            ),
            CustomSizeBox.mediumBox,
            Text(
              'Enter your 15 digit activation code to access full app features',
              style: CustomTextStyles.nameTitle,
            ),
            CustomSizeBox.box,
            Text(
              "Activation code",
              style: CustomTextStyles.mediumSubtitle,
            ),
            CustomSizeBox.littleBox,
            CustomTextField(
              obscureText: false,
              keyboardType: TextInputType.number,
              controller: _activationCodeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your activation code';
                }
                return null;
              },
            ),
            CustomSizeBox.littleBox,
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTextStyles.loginsignupButtonColor,
                  minimumSize: Size(228, 41),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Activate",
                  style: CustomTextStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _activationCodeController.dispose();
    super.dispose();
  }
}
