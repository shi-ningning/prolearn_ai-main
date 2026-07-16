import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text.dart';
import '../../../theme/text_styles.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/animated_card.dart';
import '../../state/task_provider.dart';
import '../../../data/models/task_model.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  Future<void> _loadTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await context.read<TaskProvider>().loadTasks(user.uid);
    }
  }

  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TaskPriority selectedPriority = TaskPriority.medium;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(AppText.of(context).addNewTask),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: AppText.of(context).taskTitle,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: AppText.of(context).description,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(AppText.of(context).dueDate),
                  subtitle: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppText.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppText.of(context, listen: false).pleaseEnterTaskTitle,
                      ),
                    ),
                  );
                  return;
                }

                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                final task = TaskModel(
                  id: '',
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  isCompleted: false,
                  dueDate: selectedDate,
                  userId: user.uid,
                  priority: selectedPriority,
                );

                try {
                  await context.read<TaskProvider>().addTask(task);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppText.of(context, listen: false).taskAdded,
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${AppText.of(context, listen: false).errorPrefix}: $e',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(AppText.of(context).addTask),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditTaskDialog(TaskModel task) async {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    DateTime selectedDate = task.dueDate;
    TaskPriority selectedPriority = task.priority;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(AppText.of(context).editTask),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: AppText.of(context).taskTitle,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: AppText.of(context).description,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(AppText.of(context).dueDate),
                  subtitle: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskPriority>(
                  initialValue: selectedPriority,
                  decoration: InputDecoration(
                    labelText: AppText.of(context).priority,
                    border: const OutlineInputBorder(),
                  ),
                  items: TaskPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Row(
                        children: [
                          _getPriorityIcon(priority),
                          const SizedBox(width: 8),
                          Text(_getPriorityLabel(priority)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedPriority = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppText.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppText.of(context, listen: false).pleaseEnterTaskTitle,
                      ),
                    ),
                  );
                  return;
                }

                final updatedTask = task.copyWith(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  dueDate: selectedDate,
                  priority: selectedPriority,
                );

                try {
                  await context.read<TaskProvider>().updateTask(updatedTask);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppText.of(context, listen: false).taskUpdated,
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${AppText.of(context, listen: false).errorPrefix}: $e',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(AppText.of(context).save),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask(TaskModel task) async {
    final confirmed = await _confirmDeleteTask(task);
    if (!confirmed) return;
    await _performDeleteTask(task);
  }

  Future<bool> _confirmDeleteTask(TaskModel task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.of(context).deleteTask),
        content: Text(AppText.of(context).deleteTaskConfirm(task.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppText.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppText.of(context).deleteTask),
          ),
        ],
      ),
    );

    return confirmed == true;
  }

  Future<void> _performDeleteTask(TaskModel task) async {
    final messenger = ScaffoldMessenger.of(context);
    final appText = AppText.of(context, listen: false);
    try {
      await context.read<TaskProvider>().deleteTask(task.id);
      messenger.showSnackBar(
        SnackBar(
          content: Text(appText.taskDeleted),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('${appText.errorPrefix}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return AppText.of(context).overdue;
    } else if (difference == 0) {
      return AppText.of(context).dueToday;
    } else if (difference == 1) {
      return AppText.of(context).dueTomorrow;
    } else {
      return AppText.of(context).dueInDays(difference);
    }
  }

  Icon _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return const Icon(Icons.priority_high, color: Colors.red, size: 20);
      case TaskPriority.medium:
        return const Icon(Icons.remove, color: Colors.orange, size: 20);
      case TaskPriority.low:
        return const Icon(Icons.arrow_downward, color: Colors.green, size: 20);
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppText.of(context).high;
      case TaskPriority.medium:
        return AppText.of(context).medium;
      case TaskPriority.low:
        return AppText.of(context).low;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ProLearn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: colorScheme.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: colorScheme.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Text(
              AppText.of(context).tasks,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colorScheme.onSurface),
            onPressed: _showAddTaskDialog,
            tooltip: AppText.of(context).addTask,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    FirebaseAuth.instance.currentUser?.displayName
                            ?.substring(0, 1)
                            .toUpperCase() ??
                        'U',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
      ),
      drawer: const Sidebar(),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Search and Filter Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.surface,
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: AppText.of(context).searchTasks,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: taskProvider.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  taskProvider.setSearchQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        taskProvider.setSearchQuery(value);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Filter and Sort Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<TaskFilter>(
                            initialValue: taskProvider.currentFilter,
                            decoration: InputDecoration(
                              labelText: AppText.of(context).filter,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: TaskFilter.all,
                                child: Text(AppText.of(context).allTasks),
                              ),
                              DropdownMenuItem(
                                value: TaskFilter.pending,
                                child: Text(AppText.of(context).pending),
                              ),
                              DropdownMenuItem(
                                value: TaskFilter.completed,
                                child: Text(AppText.of(context).completed),
                              ),
                              DropdownMenuItem(
                                value: TaskFilter.overdue,
                                child: Text(AppText.of(context).overdueFilter),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                taskProvider.setFilter(value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<TaskSort>(
                            initialValue: taskProvider.currentSort,
                            decoration: InputDecoration(
                              labelText: AppText.of(context).sort,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: TaskSort.dueDate,
                                child: Text(AppText.of(context).sortDueDate),
                              ),
                              DropdownMenuItem(
                                value: TaskSort.priority,
                                child: Text(AppText.of(context).sortPriority),
                              ),
                              DropdownMenuItem(
                                value: TaskSort.createdAt,
                                child: Text(AppText.of(context).sortCreated),
                              ),
                              DropdownMenuItem(
                                value: TaskSort.title,
                                child: Text(AppText.of(context).sortTitle),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                taskProvider.setSort(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tasks List
              Expanded(child: _buildTasksList(taskProvider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTasksList(TaskProvider taskProvider) {
    final tasks = taskProvider.tasks;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              taskProvider.searchQuery.isNotEmpty
                  ? AppText.of(context).noTasksFound
                  : AppText.of(context).noTasksYet,
              style: TextStyles.headline(context).copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              taskProvider.searchQuery.isNotEmpty
                  ? AppText.of(context).tryAdjustSearch
                  : AppText.of(context).tapPlusToAdd,
              style: TextStyles.body(context).copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final isOverdue =
              task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;

          return Dismissible(
            key: ValueKey(task.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              final confirmed = await _confirmDeleteTask(task);
              if (confirmed) {
                await _performDeleteTask(task);
              }
              return confirmed;
            },
            background: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            child: AnimatedCard(
              margin: const EdgeInsets.only(bottom: 12),
              backgroundColor: isOverdue
                  ? Colors.red.withValues(alpha: 0.1)
                  : null,
              onTap: () {
                // Show task details or edit
                _showEditTaskDialog(task);
              },
              onLongPress: () async {
                await taskProvider.toggleTaskCompletion(task);
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: task.isCompleted
                      ? AppColors.tertiary.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.2),
                  child: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.assignment,
                    color: task.isCompleted
                        ? AppColors.tertiary
                        : AppColors.primary,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyles.body(context).copyWith(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _getPriorityIcon(task.priority),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.description.isNotEmpty) ...[
                      Text(
                        task.description,
                        style: TextStyles.caption(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      _formatDate(task.dueDate),
                      style: TextStyles.caption(context).copyWith(
                        color: isOverdue
                            ? Colors.red
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: isOverdue
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.isCompleted
                            ? AppColors.tertiary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () async {
                        await taskProvider.toggleTaskCompletion(task);
                      },
                      tooltip: task.isCompleted
                          ? AppText.of(context).markIncomplete
                          : AppText.of(context).markComplete,
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text(AppText.of(context).editTask),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                AppText.of(context).deleteTask,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditTaskDialog(task);
                        } else if (value == 'delete') {
                          _deleteTask(task);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
