import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/animated_card.dart';
import '../../state/project_provider.dart';
import '../../../data/models/project_model.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProjects();
    });
  }

  Future<void> _loadProjects() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await context.read<ProjectProvider>().loadProjects(user.uid);
    }
  }

  Future<void> _showAddProjectDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final tagsController = TextEditingController();
    DateTime? selectedDate;
    ProjectPriority selectedPriority = ProjectPriority.medium;
    String? selectedColor = AppColors.primary.toARGB32().toRadixString(16);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final colorScheme = Theme.of(context).colorScheme;
          return AlertDialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              AppText.of(context).addNewProject,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).projectTitle,
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
                  TextField(
                    controller: tagsController,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).addTags,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ProjectPriority>(
                    initialValue: selectedPriority,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).priority,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: ProjectPriority.low,
                        child: Text(AppText.of(context).low),
                      ),
                      DropdownMenuItem(
                        value: ProjectPriority.medium,
                        child: Text(AppText.of(context).medium),
                      ),
                      DropdownMenuItem(
                        value: ProjectPriority.high,
                        child: Text(AppText.of(context).high),
                      ),
                      DropdownMenuItem(
                        value: ProjectPriority.critical,
                        child: Text(AppText.of(context).critical),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPriority = value ?? ProjectPriority.medium;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(AppText.of(context).dueDate),
                    subtitle: Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Optional',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          const Duration(days: 7),
                        ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a project title'),
                        backgroundColor: colorScheme.error,
                      ),
                    );
                    return;
                  }

                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;

                  final tags = tagsController.text
                      .split(',')
                      .map((t) => t.trim())
                      .where((t) => t.isNotEmpty)
                      .toList();

                  final project = ProjectModel(
                    id: '',
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    userId: user.uid,
                    priority: selectedPriority,
                    dueDate: selectedDate,
                    tags: tags,
                    color: selectedColor,
                  );

                  // Capture text before async operation
                  final projectAddedText = AppText.of(
                    context,
                    listen: false,
                  ).projectAdded;

                  final success = await context
                      .read<ProjectProvider>()
                      .createProject(project);

                  if (!context.mounted) return;
                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(projectAddedText),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text(AppText.of(context).addProject),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showEditProjectDialog(ProjectModel project) async {
    final titleController = TextEditingController(text: project.title);
    final descriptionController = TextEditingController(
      text: project.description,
    );
    final tagsController = TextEditingController(text: project.tags.join(', '));
    DateTime? selectedDate = project.dueDate;
    ProjectPriority selectedPriority = project.priority;
    ProjectStatus selectedStatus = project.status;
    int selectedProgress = project.progress;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final colorScheme = Theme.of(context).colorScheme;
          return AlertDialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              AppText.of(context).editProject,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).projectTitle,
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
                  TextField(
                    controller: tagsController,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).tags,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ProjectStatus>(
                    initialValue: selectedStatus,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).projectStatus,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: ProjectStatus.active,
                        child: Text(AppText.of(context).active),
                      ),
                      DropdownMenuItem(
                        value: ProjectStatus.completed,
                        child: Text(AppText.of(context).completed),
                      ),
                      DropdownMenuItem(
                        value: ProjectStatus.onHold,
                        child: Text(AppText.of(context).onHold),
                      ),
                      DropdownMenuItem(
                        value: ProjectStatus.archived,
                        child: Text(AppText.of(context).archived),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedStatus = value ?? ProjectStatus.active;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppText.of(context).projectProgress}: $selectedProgress%',
                      ),
                      Slider(
                        value: selectedProgress.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        label: '$selectedProgress%',
                        onChanged: (value) {
                          setDialogState(() {
                            selectedProgress = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ProjectPriority>(
                    initialValue: selectedPriority,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).priority,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: ProjectPriority.low,
                        child: Text(AppText.of(context).low),
                      ),
                      DropdownMenuItem(
                        value: ProjectPriority.medium,
                        child: Text(AppText.of(context).medium),
                      ),
                      DropdownMenuItem(
                        value: ProjectPriority.high,
                        child: Text(AppText.of(context).high),
                      ),
                      DropdownMenuItem(
                        value: ProjectPriority.critical,
                        child: Text(AppText.of(context).critical),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPriority = value ?? ProjectPriority.medium;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(AppText.of(context).dueDate),
                    subtitle: Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'No due date',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final tags = tagsController.text
                      .split(',')
                      .map((t) => t.trim())
                      .where((t) => t.isNotEmpty)
                      .toList();

                  final updatedProject = project.copyWith(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    status: selectedStatus,
                    priority: selectedPriority,
                    progress: selectedProgress,
                    dueDate: selectedDate,
                    tags: tags,
                  );

                  // Capture text before async operation
                  final projectUpdatedText = AppText.of(
                    context,
                    listen: false,
                  ).projectUpdated;

                  final success = await context
                      .read<ProjectProvider>()
                      .updateProject(project.id, updatedProject);

                  if (!context.mounted) return;
                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(projectUpdatedText),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text(AppText.of(context).save),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteProject(ProjectModel project) async {
    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppText.of(context).delete,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Text(
          AppText.of(context).deleteProjectConfirm(project.title),
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppText.of(context).cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppText.of(context).delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Capture text before async operation
      final projectDeletedText = AppText.of(
        context,
        listen: false,
      ).projectDeleted;

      final success = await context.read<ProjectProvider>().deleteProject(
        project.id,
      );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(projectDeletedText),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Color _getPriorityColor(ProjectPriority priority) {
    switch (priority) {
      case ProjectPriority.low:
        return Colors.green;
      case ProjectPriority.medium:
        return Colors.orange;
      case ProjectPriority.high:
        return Colors.red;
      case ProjectPriority.critical:
        return Colors.purple;
    }
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.active:
        return Colors.blue;
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.onHold:
        return Colors.orange;
      case ProjectStatus.archived:
        return Colors.grey;
    }
  }

  String _getStatusText(BuildContext context, ProjectStatus status) {
    switch (status) {
      case ProjectStatus.active:
        return AppText.of(context).active;
      case ProjectStatus.completed:
        return AppText.of(context).completed;
      case ProjectStatus.onHold:
        return AppText.of(context).onHold;
      case ProjectStatus.archived:
        return AppText.of(context).archived;
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
              AppText.of(context).yourProjects,
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
          PopupMenuButton<ProjectFilter>(
            icon: Icon(Icons.filter_list, color: colorScheme.onSurface),
            onSelected: (filter) {
              context.read<ProjectProvider>().setFilter(filter);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ProjectFilter.all,
                child: Text(AppText.of(context).allProjects),
              ),
              PopupMenuItem(
                value: ProjectFilter.active,
                child: Text(AppText.of(context).activeProjects),
              ),
              PopupMenuItem(
                value: ProjectFilter.completed,
                child: Text(AppText.of(context).completedProjects),
              ),
              PopupMenuItem(
                value: ProjectFilter.onHold,
                child: Text(AppText.of(context).onHoldProjects),
              ),
              PopupMenuItem(
                value: ProjectFilter.archived,
                child: Text(AppText.of(context).archivedProjects),
              ),
            ],
          ),
          PopupMenuButton<ProjectSort>(
            icon: Icon(Icons.sort, color: colorScheme.onSurface),
            onSelected: (sort) {
              context.read<ProjectProvider>().setSort(sort);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ProjectSort.createdAt,
                child: Text(AppText.of(context).sortCreated),
              ),
              PopupMenuItem(
                value: ProjectSort.dueDate,
                child: Text(AppText.of(context).sortDueDate),
              ),
              PopupMenuItem(
                value: ProjectSort.priority,
                child: Text(AppText.of(context).sortPriority),
              ),
              PopupMenuItem(
                value: ProjectSort.progress,
                child: Text(AppText.of(context).projectProgress),
              ),
              PopupMenuItem(
                value: ProjectSort.title,
                child: Text(AppText.of(context).sortTitle),
              ),
            ],
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
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          if (projectProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            );
          }

          final projects = projectProvider.projects;

          if (projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 80,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppText.of(context).noProjects,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppText.of(context).noProjectsSubtitle,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return AnimatedCard(
                margin: const EdgeInsets.only(bottom: 16),
                useGlassmorphism: false,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showEditProjectDialog(project),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _getPriorityColor(project.priority),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            project.status,
                                          ).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          _getStatusText(
                                            context,
                                            project.status,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _getStatusColor(
                                              project.status,
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: colorScheme.error,
                              ),
                              onPressed: () => _deleteProject(project),
                            ),
                          ],
                        ),
                        if (project.description.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            project.description,
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: project.progress / 100,
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${project.progress}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            if (project.dueDate != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${project.dueDate!.day}/${project.dueDate!.month}/${project.dueDate!.year}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        if (project.tags.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: project.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProjectDialog,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: Text(AppText.of(context).addProject),
      ),
    );
  }
}
