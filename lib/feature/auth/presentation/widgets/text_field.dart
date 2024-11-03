// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ited_study/core/constants/text_style.dart.dart';

class CustomTextField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputType keyboardType;

  final String? Function(String?)? onChanged;
  const CustomTextField({
    super.key,
    required this.obscureText,
    required this.controller,
    this.onTap,
    this.validator,
    this.focusNode,
    required this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onTap: onTap,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
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
    );
  }
}
