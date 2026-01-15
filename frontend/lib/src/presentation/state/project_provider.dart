import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';
import '../../utils/logger.dart';

enum ProjectFilter { all, active, completed, onHold, archived }
enum ProjectSort { createdAt, dueDate, priority, title, progress }

class ProjectProvider with ChangeNotifier {
  List<ProjectModel> _projects = [];
  final ProjectRepository _projectRepository = ProjectRepository();
  bool _isLoading = false;
  ProjectFilter _currentFilter = ProjectFilter.all;
  ProjectSort _currentSort = ProjectSort.createdAt;
  String _searchQuery = '';
  StreamSubscription<List<ProjectModel>>? _projectsStreamSubscription;

  List<ProjectModel> get projects => _getFilteredAndSortedProjects();
  List<ProjectModel> get allProjects => _projects;
  bool get isLoading => _isLoading;
  ProjectFilter get currentFilter => _currentFilter;
  ProjectSort get currentSort => _currentSort;
  String get searchQuery => _searchQuery;

  List<ProjectModel> get activeProjects =>
      _projects.where((p) => p.status == ProjectStatus.active).toList();
  List<ProjectModel> get completedProjects =>
      _projects.where((p) => p.status == ProjectStatus.completed).toList();
  List<ProjectModel> get onHoldProjects =>
      _projects.where((p) => p.status == ProjectStatus.onHold).toList();

  void setFilter(ProjectFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSort(ProjectSort sort) {
    _currentSort = sort;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<ProjectModel> _getFilteredAndSortedProjects() {
    var filtered = _projects;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((project) {
        return project.title.toLowerCase().contains(_searchQuery) ||
            project.description.toLowerCase().contains(_searchQuery) ||
            project.tags.any((tag) => tag.toLowerCase().contains(_searchQuery));
      }).toList();
    }

    // Apply status filter
    switch (_currentFilter) {
      case ProjectFilter.active:
        filtered = filtered.where((p) => p.status == ProjectStatus.active).toList();
        break;
      case ProjectFilter.completed:
        filtered = filtered.where((p) => p.status == ProjectStatus.completed).toList();
        break;
      case ProjectFilter.onHold:
        filtered = filtered.where((p) => p.status == ProjectStatus.onHold).toList();
        break;
      case ProjectFilter.archived:
        filtered = filtered.where((p) => p.status == ProjectStatus.archived).toList();
        break;
      case ProjectFilter.all:
        break;
    }

    // Apply sorting
    switch (_currentSort) {
      case ProjectSort.title:
        filtered.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case ProjectSort.priority:
        filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case ProjectSort.dueDate:
        filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case ProjectSort.progress:
        filtered.sort((a, b) => b.progress.compareTo(a.progress));
        break;
      case ProjectSort.createdAt:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return filtered;
  }

  Future<void> loadProjects(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _projectsStreamSubscription?.cancel();
      _projectsStreamSubscription = _projectRepository.getProjectsStream(userId).listen(
        (projects) {
          _projects = projects;
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          Logger.error('Error loading projects: $error');
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      Logger.error('Error setting up projects stream: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProject(ProjectModel project) async {
    try {
      final projectId = await _projectRepository.createProject(project);
      if (projectId != null) {
        Logger.info('Project created successfully');
        return true;
      }
      return false;
    } catch (e) {
      Logger.error('Error creating project: $e');
      return false;
    }
  }

  Future<bool> updateProject(String projectId, ProjectModel project) async {
    try {
      final success = await _projectRepository.updateProject(projectId, project);
      if (success) {
        Logger.info('Project updated successfully');
      }
      return success;
    } catch (e) {
      Logger.error('Error updating project: $e');
      return false;
    }
  }

  Future<bool> deleteProject(String projectId) async {
    try {
      final success = await _projectRepository.deleteProject(projectId);
      if (success) {
        Logger.info('Project deleted successfully');
      }
      return success;
    } catch (e) {
      Logger.error('Error deleting project: $e');
      return false;
    }
  }

  Future<bool> updateProgress(String projectId, int progress) async {
    try {
      return await _projectRepository.updateProgress(projectId, progress);
    } catch (e) {
      Logger.error('Error updating progress: $e');
      return false;
    }
  }

  Future<bool> updateStatus(String projectId, ProjectStatus status) async {
    try {
      return await _projectRepository.updateStatus(projectId, status);
    } catch (e) {
      Logger.error('Error updating status: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _projectsStreamSubscription?.cancel();
    super.dispose();
  }
}
