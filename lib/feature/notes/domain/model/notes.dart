import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'notes.g.dart';

@HiveType(typeId: 35)
class Note {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String topicId;

  @HiveField(2)
  final List<NoteContent> notes;

  @HiveField(3)
  final int version;

  Note({
    required this.id,
    required this.topicId,
    required this.notes,
    required this.version,
  });

  // Factory method for deserializing from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'] as String,
      topicId: json['topicId'] as String,
      notes: (json['notes'] as List<dynamic>)
          .map((note) => NoteContent.fromJson(note as Map<String, dynamic>))
          .toList(),
      version: json['__v'] as int,
    );
  }
}

@HiveType(typeId: 36)
class NoteContent {
  @HiveField(0)
  final String insert;

  @HiveField(1)
  final Map<String, dynamic>? attributes;

  NoteContent({
    required this.insert,
    this.attributes,
  });

  // Factory method for deserializing from JSON
  factory NoteContent.fromJson(Map<String, dynamic> json) {
    var insertData = json['insert'];

    // Check if insert is a String (text) or an Object (like an image)
    String insertText = '';
    if (insertData is String) {
      insertText = insertData; // Normal text
    } else if (insertData is Map<String, dynamic>) {
      insertText = jsonEncode(insertData); // Handle object (image) as a string
    }

    return NoteContent(
      insert: insertText,
      attributes: json['attributes'] as Map<String, dynamic>?,
    );
  }
}
