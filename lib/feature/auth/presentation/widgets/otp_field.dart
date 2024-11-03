// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ited_study/core/constants/text_style.dart.dart';

class OTPField extends StatelessWidget {
  final TextEditingController controller;
  const OTPField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SizedBox(
        width: 50,
        height: 50,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: CustomTextStyles.loginsignupButtonColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: CustomTextStyles.loginsignupButtonColor,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: CustomTextStyles.loginsignupButtonColor,
                width: 2.5,
              ),
            ),
          ),
          onSaved: (pin) {},
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }
}
