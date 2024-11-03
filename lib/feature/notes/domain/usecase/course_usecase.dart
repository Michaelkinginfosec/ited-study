import 'package:ited_study/feature/notes/domain/repository/course_repository.dart';

class CourseUsecase {
  final CourseRepository courseRepository;
  CourseUsecase(this.courseRepository);
  Future<String> getCourses() async {
    return await courseRepository.getCourses();
  }
}
