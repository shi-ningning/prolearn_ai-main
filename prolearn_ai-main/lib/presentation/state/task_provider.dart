import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  final TaskRepository _taskRepository = TaskRepository();

  List<TaskModel> get tasks => _tasks;

  Future<void> loadTasks(String userId) async {
    _tasks = await _taskRepository.getTasks(userId);
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await _taskRepository.saveTask(task);
    _tasks.add(task);
    notifyListeners();
  }
}
