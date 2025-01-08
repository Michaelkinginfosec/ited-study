import '../repository/course_repository.dart';

class TopicUsecase {
  final CourseRepository courseRepository;
  TopicUsecase(this.courseRepository);
  Future<void> getTopics(String schoolId, String level) async {
    return await courseRepository.getTopics(schoolId, level);
  }
}
