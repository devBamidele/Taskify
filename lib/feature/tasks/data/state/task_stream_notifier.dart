import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../repository/task_repository.dart';
import 'task_stream_state.dart';

class TaskStreamNotifier extends StateNotifier<TaskStreamState> {
  final TaskRepository _taskRepository;

  TaskStreamNotifier(Ref ref)
      : _taskRepository = ref.read(taskRepositoryProvider),
        super(const TaskStreamState.initial()) {
    _initializeStream();
  }

  void _initializeStream() {
    state = const TaskStreamState.loading();

    _taskRepository.streamTasks().listen((tasksOrError) {
      tasksOrError.fold(
        (err) {
          state = TaskStreamState.streamError(err);
        },
        (tasks) {
          state = TaskStreamState.streaming(tasks);
        },
      );
    });
  }
}
