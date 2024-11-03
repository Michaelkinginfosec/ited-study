import 'package:ited_study/feature/notes/data/datasource/course_datasource.dart';
import 'package:ited_study/feature/notes/domain/repository/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseDatasource courseDatasource;
  CourseRepositoryImpl(this.courseDatasource);

  @override
  Future<String> getCourses() async {
    return await courseDatasource.getCourses();
  }

  @override
  Future<void> getTopics() async {
    return await courseDatasource.getTopics();
  }
}
