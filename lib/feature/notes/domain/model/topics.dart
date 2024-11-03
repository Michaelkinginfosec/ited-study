import 'package:hive_flutter/hive_flutter.dart';

part 'topics.g.dart';

@HiveType(typeId: 2)
class Topics extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String courseId;

  @HiveField(2)
  String topic;

  Topics({
    required this.id,
    required this.courseId,
    required this.topic,
  });

  factory Topics.fromJson(Map<String, dynamic> json) {
    return Topics(
      id: json['_id'],
      courseId: json['courseId'],
      topic: json['topic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'courseId': courseId,
      'topic': topic,
    };
  }
}
