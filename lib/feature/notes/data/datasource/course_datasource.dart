import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/errors/errors.dart';
import '../../domain/model/courses.dart';
import '../../domain/model/notes.dart';
import '../../domain/model/topics.dart';

abstract class CourseDatasource {
  Future<String> getCourses();
  Future<void> getTopics();
  Future<void> note();
}

class CourseDatasourceImp implements CourseDatasource {
  final Dio dio;
  CourseDatasourceImp(this.dio);

  @override
  Future<String> getCourses() async {
    await test();
    await note();
    try {
      final response = await dio.get(
        '/notes',
      );
      if (response.statusCode == 200) {
        List<Courses> courses = (response.data as List)
            .map(
              (json) => Courses.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();

        await storeCourses(courses);

        return 'Courses fetched successfully';
      } else {
        throw Exception('Failed to load courses');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404 || e.response!.statusCode == 400) {
          throw Exception('No courses available');
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw SignUpException("Unexpected Error occurred $e ");
    }
  }

  Future<void> storeCourses(List<Courses> courses) async {
    final box = await Hive.openBox<Courses>('courses');
    box.clear();
    for (var course in courses) {
      await box.put(course.id, course);
    }
  }

  @override
  Future<void> getTopics() async {
    try {
      final response = await dio.get('/notes/course-topics');
      if (response.statusCode == 200) {
        if (response.data is List) {
          List<Topics> topics = (response.data as List)
              .map((json) => Topics.fromJson(json as Map<String, dynamic>))
              .toList();
          await storeTopics(topics);
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404 || e.response!.statusCode == 400) {
          throw Exception('No topics available');
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> storeTopics(List<Topics> topics) async {
    var box = Hive.box<Topics>('topic');

    await box.clear();

    for (var topic in topics) {
      await box.add(topic);
    }
  }

  @override
  Future<void> note() async {
    try {
      final response = await dio.get("/notes/notes");
      if (response.statusCode == 200) {
        if (response.data != null && response.data is List) {
          final List<Note> notes = (response.data as List<dynamic>)
              .map((json) => Note.fromJson(json as Map<String, dynamic>))
              .toList();

          // Save to Hive
          var box = Hive.box<Note>('notesBox');
          await box.clear(); // Clear previous data

          for (var note in notes) {
            await box.add(note); // Add each note to Hive
          }
        } else {
          throw Exception('Response data is not a list or is empty');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404 || e.response!.statusCode == 400) {
          throw Exception('No topics available');
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> test() async {
    try {
      final response = await dio.get("/questions/test-questions");
      if (response.statusCode == 200) {
        if (response.data != null && response.data is List) {
          List responseData = response.data as List;
          var box = Hive.box('question');
          await box.addAll(responseData);
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404 || e.response!.statusCode == 400) {
          throw Exception('No topics available');
        } else {
          throw Exception('Failed with status code: ${e.response!.statusCode}');
        }
      } else {
        throw Exception('Network or server error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error occurred: ${e.toString()}');
    }
  }
}
