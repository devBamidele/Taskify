import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/task.dart';

part 'task_stream_state.freezed.dart';

@freezed
class TaskStreamState with _$TaskStreamState {
  const factory TaskStreamState.initial() = _Initial;
  const factory TaskStreamState.loading() = _Loading;
  const factory TaskStreamState.streamError(String message) = _StreamError;
  const factory TaskStreamState.streaming(List<Task> tasks) = _Streaming;
}
