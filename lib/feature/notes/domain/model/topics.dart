import 'package:hive_flutter/hive_flutter.dart';

part 'topics.g.dart';

@HiveType(typeId: 2)
class Topics {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String course;

  @HiveField(2)
  final String courseId;

  @HiveField(3)
  final String topic;

  Topics({
    required this.id,
    required this.course,
    required this.courseId,
    required this.topic,
  });

  factory Topics.fromJson(Map<String, dynamic> json) {
    return Topics(
      id: json['_id'] ?? '', // Fallback to empty string if null
      course: json['course'] ?? '', // Fallback to empty string if null
      courseId: json['courseId'] ?? '', // Fallback to empty string if null
      topic: json['topic'] ?? '', // Fallback to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'course': course,
      'courseId': courseId,
      'topic': topic,
    };
  }
}
