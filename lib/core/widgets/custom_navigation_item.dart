// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class CustomNavigationItem extends ConsumerWidget {
  final int index;
  final int currentIndex;
  final String icon;

  const CustomNavigationItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.watch(navigationIndexProvider.notifier).state = index;
      },
      child: Image.asset(
        icon,
        height: 30,
        color: currentIndex == index
            ? Color.fromRGBO(0, 5, 45, 1)
            : Color.fromRGBO(111, 103, 103, 1),
        // : Colors.red,
      ),
    );
  }
}
