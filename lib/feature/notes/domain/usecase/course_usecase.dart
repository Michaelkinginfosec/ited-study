import 'package:ited_study/feature/notes/domain/repository/course_repository.dart';

class CourseUsecase {
  final CourseRepository courseRepository;
  CourseUsecase(this.courseRepository);
  Future<String> getCourses(String schoolId, String level) async {
    return await courseRepository.getCourses(schoolId, level);
  }
}
