abstract class CourseRepository {
  Future<void> getTopics(String schoolId, String level);
  Future<String> getCourses(String schoolId, String level);
}
