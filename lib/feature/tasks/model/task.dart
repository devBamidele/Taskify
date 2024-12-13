import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../constants/index.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? subTitle,
    required DateTime time,
    required TaskPriority priority,
    @Default(false) bool isCompleted,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
