import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/task.dart';

/// All the [CRUD] operetion method for hive DB
class HiveDataStore {
  /// Box Name - String
  static const boxName = 'taskBox';
  /// Our current Box with all the saved data inside - Box<Task>
  final Box<Task>box = Hive.box<Task>(boxName);

  /// Add New Task To Box
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  /// Show Task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  ///Update Task
  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  /// Delete Task
  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  /// Listen to Box Change
  /// Using this method we will listen to box change and update UI accordingly
  ValueListenable<Box<Task>> listenToTask() => box.listenable();
}