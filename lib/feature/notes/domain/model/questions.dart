import 'package:hive_flutter/hive_flutter.dart';

part 'questions.g.dart';

@HiveType(typeId: 13)
class Question extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String courseId;

  @HiveField(2)
  String topicId;

  @HiveField(3)
  String year;

  @HiveField(4)
  String question;

  @HiveField(5)
  List<Option> options;

  @HiveField(6)
  String correctAnswer;

  @HiveField(7)
  String explanation;

  Question({
    required this.id,
    required this.courseId,
    required this.topicId,
    required this.year,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}

@HiveType(typeId: 14)
class Option extends HiveObject {
  @HiveField(0)
  String label;

  @HiveField(1)
  String text;

  Option({
    required this.label,
    required this.text,
  });
}
