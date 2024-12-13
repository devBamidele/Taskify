import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_cud_state.freezed.dart';

@freezed
class TaskCudState with _$TaskCudState {
  const factory TaskCudState.initial() = _Initial;
  const factory TaskCudState.loading() = _Loading;
  const factory TaskCudState.success() = _Success;
  const factory TaskCudState.error(String message) = _Error;
}
