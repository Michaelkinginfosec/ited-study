import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/feature/auth/data/models/users.dart';
import 'package:ited_study/feature/notes/domain/model/courses.dart';
import 'core/route/route_config.dart';
import 'feature/notes/domain/model/notes.dart';
import 'feature/notes/domain/model/topics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CoursesAdapter());
  Hive.registerAdapter(UsersAdapter());
  Hive.registerAdapter(TopicsAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteContentAdapter());
  await Hive.openBox<Topics>('topic');
  await Hive.openBox('textTopic');
  await Hive.openBox('textCourse');
  await Hive.openBox<Note>('notesBox');
  await Hive.openBox<Courses>('courses');
  await Hive.openBox("sessionBox");
  await Hive.openBox('school');
  await Hive.openBox("usersBox");
  await Hive.openBox('gp');
  await Hive.openBox('question');
  await Hive.openBox('examQuestion');
  await Hive.openBox('countries');

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
