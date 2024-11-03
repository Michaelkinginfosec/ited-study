import '../repository/course_repository.dart';

class TopicUsecase {
  final CourseRepository courseRepository;
  TopicUsecase(this.courseRepository);
  Future<void> getTopics() async {
    return await courseRepository.getTopics();
  }
}
