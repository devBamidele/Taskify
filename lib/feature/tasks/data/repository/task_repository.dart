import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/core/providers/providers.dart';

import '../../model/task.dart';
import '../source/remote_source.dart';

abstract class TaskRepository {
  Stream<Either<String, List<Task>>> streamTasks();
  Future<Either<String, void>> createTask(Task task);
  Future<Either<String, void>> updateTask(Task task);
  Future<Either<String, void>> removeTask(String taskId);
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteSource _taskRemoteSource;

  TaskRepositoryImpl(Ref ref)
      : _taskRemoteSource = ref.read(taskRemoteSourceProvider);

  @override
  Stream<Either<String, List<Task>>> streamTasks() =>
      _taskRemoteSource.streamTasks();

  @override
  Future<Either<String, void>> createTask(Task task) async {
    return await _taskRemoteSource.addTask(task);
  }

  @override
  Future<Either<String, void>> updateTask(Task task) async {
    return await _taskRemoteSource.updateTask(task);
  }

  @override
  Future<Either<String, void>> removeTask(String taskId) async {
    return await _taskRemoteSource.deleteTask(taskId);
  }
}
