import 'package:hive_flutter/hive_flutter.dart';

Future<bool> checkFirstLaunch() async {
  final box = Hive.box('app_settings');
  final isFirstTime = box.get('isFirstLaunch', defaultValue: true);

  if (isFirstTime) {
    await box.put('isFirstLaunch', false);
  }

  return isFirstTime;
}
