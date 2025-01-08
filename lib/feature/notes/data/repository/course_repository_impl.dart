import 'package:ited_study/feature/notes/data/datasource/course_datasource.dart';
import 'package:ited_study/feature/notes/domain/repository/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseDatasource courseDatasource;
  CourseRepositoryImpl(this.courseDatasource);

  @override
  Future<String> getCourses(String schoolId, String level) async {
    return await courseDatasource.getCourses(schoolId, level);
  }

  @override
  Future<void> getTopics(String schoolId, String level) async {
    return await courseDatasource.getTopics(schoolId, level);
  }
}
