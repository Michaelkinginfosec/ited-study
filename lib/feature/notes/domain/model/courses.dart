import 'package:hive_flutter/hive_flutter.dart';

part 'courses.g.dart';

@HiveType(typeId: 0)
class Courses extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String courseName;

  @HiveField(2)
  String courseTitle;

  @HiveField(3)
  String courseCode;

  @HiveField(4)
  String courseImage;

  Courses({
    required this.id,
    required this.courseName,
    required this.courseTitle,
    required this.courseCode,
    required this.courseImage,
  });

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      id: json['_id'],
      courseName: json['courseName'],
      courseTitle: json['courseTitle'],
      courseCode: json['courseCode'],
      courseImage: json['courseImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'courseName': courseName,
      'courseTitle': courseTitle,
      'courseCode': courseCode,
      'courseImage': courseImage,
    };
  }
}
