// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget subTitle;
  final Widget title;

  const CustomListTile({
    super.key,
    required this.subTitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: title,
        subtitle: subTitle,
      ),
    );
  }
}
