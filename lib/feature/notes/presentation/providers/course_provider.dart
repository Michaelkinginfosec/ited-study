import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/notes/domain/usecase/course_usecase.dart';

enum CourseStatus { loading, success, initial, error }

class CourseState {
  final CourseStatus status;
  final String? message;
  final String? error;
  CourseState({
    this.status = CourseStatus.initial,
    this.message,
    this.error,
  });

  CourseState copyWith({
    CourseStatus? status,
    String? error,
    String? message,
  }) {
    return CourseState(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}

class CourseNotifier extends StateNotifier<CourseState> {
  final CourseUsecase courseUsecase;
  CourseNotifier(this.courseUsecase) : super(CourseState());

  Future<void> getCourses() async {
    state = state.copyWith(status: CourseStatus.loading);
    try {
      await courseUsecase.getCourses();
      state = state.copyWith(status: CourseStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: CourseStatus.error,
        error: e.toString(),
      );
    }
  }
}

final courseNotifierProvider =
    StateNotifierProvider<CourseNotifier, CourseState>(
  (ref) {
    return CourseNotifier(
      ref.read(courseUsecaseProvider),
    );
  },
);
