import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../model/task.dart';
import '../repository/task_repository.dart';
import 'task_cud_state.dart';

class TaskCudNotifier extends StateNotifier<TaskCudState> {
  final TaskRepository _taskRepository;

  TaskCudNotifier(Ref ref)
      : _taskRepository = ref.read(taskRepositoryProvider),
        super(const TaskCudState.initial());

  Future<void> createTask(Task task) async {
    state = const TaskCudState.loading();

    final result = await _taskRepository.createTask(task);

    result.fold(
      (err) {
        state = TaskCudState.error(err);
      },
      (_) {
        state = const TaskCudState.success();
      },
    );
  }

  Future<void> updateTask(Task task) async {
    state = const TaskCudState.loading();

    final result = await _taskRepository.updateTask(task);

    result.fold(
      (err) {
        state = TaskCudState.error(err);
      },
      (_) {
        state = const TaskCudState.success();
      },
    );
  }

  Future<void> deleteTask(String taskId) async {
    state = const TaskCudState.loading();

    final result = await _taskRepository.removeTask(taskId);

    result.fold(
      (err) {
        state = TaskCudState.error(err);
      },
      (_) {
        state = const TaskCudState.success();
      },
    );
  }
}
