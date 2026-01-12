import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../core/utils/logger.dart';

enum TaskFilter { all, pending, completed, overdue }
enum TaskSort { dueDate, priority, createdAt, title }

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  final TaskRepository _taskRepository = TaskRepository();
  bool _isLoading = false;
  TaskFilter _currentFilter = TaskFilter.all;
  TaskSort _currentSort = TaskSort.dueDate;
  String _searchQuery = '';
  StreamSubscription<List<TaskModel>>? _tasksStreamSubscription;

  List<TaskModel> get tasks => _getFilteredAndSortedTasks();
  List<TaskModel> get allTasks => _tasks;
  bool get isLoading => _isLoading;
  TaskFilter get currentFilter => _currentFilter;
  TaskSort get currentSort => _currentSort;
  String get searchQuery => _searchQuery;
  
  List<TaskModel> get completedTasks => _tasks.where((t) => t.isCompleted).toList();
  List<TaskModel> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<TaskModel> get overdueTasks => _tasks.where((t) => 
    !t.isCompleted && t.dueDate.isBefore(DateTime.now())).toList();

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSort(TaskSort sort) {
    _currentSort = sort;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<TaskModel> _getFilteredAndSortedTasks() {
    var filtered = _tasks;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(_searchQuery) ||
               task.description.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply status filter
    switch (_currentFilter) {
      case TaskFilter.pending:
        filtered = filtered.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.completed:
        filtered = filtered.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.overdue:
        filtered = filtered.where((t) => 
          !t.isCompleted && t.dueDate.isBefore(DateTime.now())).toList();
        break;
      case TaskFilter.all:
        break;
    }

    // Apply sorting
    switch (_currentSort) {
      case TaskSort.dueDate:
        filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case TaskSort.priority:
        filtered.sort((a, b) {
          final priorityOrder = {TaskPriority.high: 3, TaskPriority.medium: 2, TaskPriority.low: 1};
          return priorityOrder[b.priority]!.compareTo(priorityOrder[a.priority]!);
        });
        break;
      case TaskSort.createdAt:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSort.title:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return filtered;
  }

  Future<void> loadTasks(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Cancel existing stream if any
      await _tasksStreamSubscription?.cancel();
      
      // Load initial data
      _tasks = await _taskRepository.getTasks(userId);
      Logger.info('Loaded ${_tasks.length} tasks for user $userId');
      
      // Set up real-time stream
      _tasksStreamSubscription = _taskRepository
          .getTasksStream(userId)
          .listen(
            (tasks) {
              _tasks = tasks;
              _isLoading = false;
              notifyListeners();
              Logger.info('Real-time update: ${tasks.length} tasks');
            },
            onError: (error) {
              Logger.error('Error in tasks stream', error);
              // Keep existing tasks if stream fails
              _isLoading = false;
              notifyListeners();
            },
            cancelOnError: false, // Don't cancel on error, keep trying
          );
    } catch (e, stackTrace) {
      Logger.error('Error loading tasks', e, stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _tasksStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> addTask(TaskModel task) async {
    try {
      final taskId = await _taskRepository.saveTask(task);
      final newTask = task.copyWith(id: taskId);
      _tasks.add(newTask);
      notifyListeners();
      Logger.info('Task added: ${task.title}');
    } catch (e, stackTrace) {
      Logger.error('Error adding task', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _taskRepository.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
        Logger.info('Task updated: ${task.title}');
      }
    } catch (e, stackTrace) {
      Logger.error('Error updating task', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
      _tasks.removeWhere((t) => t.id == taskId);
      notifyListeners();
      Logger.info('Task deleted: $taskId');
    } catch (e, stackTrace) {
      Logger.error('Error deleting task', e, stackTrace);
      rethrow;
    }
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    final now = DateTime.now();
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? now : null,
    );
    await updateTask(updatedTask);
  }
}
