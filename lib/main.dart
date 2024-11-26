import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/feature/auth/data/models/users.dart';
import 'package:ited_study/feature/notes/domain/model/courses.dart';
import 'package:ited_study/feature/notes/domain/model/topics.dart';
import 'core/route/route_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CoursesAdapter());
  Hive.registerAdapter(UsersAdapter());
  Hive.registerAdapter(TopicsAdapter());
  var topics = await Hive.openBox<Topics>('topic');
  var courses = await Hive.openBox<Courses>('courses');
  var session = await Hive.openBox("sessionBox");
  var school = await Hive.openBox('school');
  var user = await Hive.openBox("usersBox");
  var gp = await Hive.openBox('gp');
  courses.get('courses');
  topics.get('topic');
  await gp.get('gp');
  await session.get('sessionBox');
  await user.get('usersBox');
  await school.get('school');

  await dotenv.load();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
