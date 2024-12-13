import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/index.dart';
import '../../../../core/providers/providers.dart';
import '../../../auth/data/source/remote_source.dart';
import '../../model/task.dart';

abstract class TaskRemoteSource {
  Stream<Either<String, List<Task>>> streamTasks();
  Future<Either<String, void>> addTask(Task task);
  Future<Either<String, void>> updateTask(Task task);
  Future<Either<String, void>> deleteTask(String taskId);
}

class TaskRemoteSourceImpl extends TaskRemoteSource {
  final FirebaseFirestore _firestore;
  final AuthRemoteSource _authSource;

  TaskRemoteSourceImpl(Ref ref)
      : _firestore = ref.read(firebaseFirestoreProvider),
        _authSource = ref.read(authRemoteSourceProvider);

  String? get _userId => _authSource.currentUserId;
  CollectionReference<Map<String, dynamic>> get _path =>
      _firestore.collection('users').doc(_userId).collection('tasks');

  @override
  Stream<Either<String, List<Task>>> streamTasks() {
    return _path.orderBy('time').snapshots().map((snapshot) {
      try {
        final tasks =
            snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
        return right(tasks);
      } on FirebaseException catch (e) {
        return left(firestoreErrMsg(e));
      } catch (e) {
        return left(AppStrings.fetchTaskFailure);
      }
    });
  }

  @override
  Future<Either<String, void>> addTask(Task task) async {
    try {
      // Use the task's ID as the document ID
      await _path.doc(task.id).set(task.toJson());
      return right(null);
    } on FirebaseException catch (e) {
      return left(firestoreErrMsg(e));
    } catch (e) {
      return left(AppStrings.addTaskFailure);
    }
  }

  @override
  Future<Either<String, void>> updateTask(Task task) async {
    try {
      await _path.doc(task.id).update(task.toJson());
      return right(null);
    } on FirebaseException catch (e) {
      return left(firestoreErrMsg(e));
    } catch (e) {
      return left(AppStrings.updateTaskFailure);
    }
  }

  @override
  Future<Either<String, void>> deleteTask(String taskId) async {
    try {
      await _path.doc(taskId).delete();
      return right(null);
    } on FirebaseException catch (e) {
      return left(firestoreErrMsg(e));
    } catch (e) {
      return left(AppStrings.deleteTaskFailure);
    }
  }
}
