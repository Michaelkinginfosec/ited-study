import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../domain/usecase/topic_usecase.dart';

enum TopicStatus { loading, success, initial, error }

class TopicState {
  final TopicStatus status;
  final String? message;
  final String? error;
  TopicState({
    this.status = TopicStatus.initial,
    this.message,
    this.error,
  });

  TopicState copyWith({
    TopicStatus? status,
    String? error,
    String? message,
  }) {
    return TopicState(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}

class TopicNotifier extends StateNotifier<TopicState> {
  final TopicUsecase topicUsecase;
  TopicNotifier(this.topicUsecase) : super(TopicState());

  Future<void> getTopics(String schoolId, String level) async {
    state = state.copyWith(status: TopicStatus.loading);
    try {
      await topicUsecase.getTopics(schoolId, level);
      state = state.copyWith(status: TopicStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: TopicStatus.error,
        error: e.toString(),
      );
    }
  }
}

final topicNotifierProvider = StateNotifierProvider<TopicNotifier, TopicState>(
  (ref) {
    return TopicNotifier(
      ref.read(topicUsecaseProvider),
    );
  },
);
