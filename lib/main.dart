import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  var topics = await Hive.openBox<Topics>('topic');
  var textTopics = await Hive.openBox('textTopic');
  var textCourses = await Hive.openBox('textCourse');
  var notes = await Hive.openBox<Note>('notesBox');
  var courses = await Hive.openBox<Courses>('courses');
  var session = await Hive.openBox("sessionBox");
  var school = await Hive.openBox('school');
  var user = await Hive.openBox("usersBox");
  var gp = await Hive.openBox('gp');
  var question = await Hive.openBox('question');
  var examQuestion = await Hive.openBox('examQuestion');
  textTopics.get('textTopic');
  textCourses.get('textCourse');
  courses.get('courses');
  topics.get('topic');
  gp.get('gp');
  session.get('sessionBox');
  user.get('usersBox');
  school.get('school');
  notes.get('notes');
  question.get('question');
  examQuestion.get('examQuestion');
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
