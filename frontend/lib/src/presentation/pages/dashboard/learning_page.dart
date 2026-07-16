import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text.dart';
import '../../../theme/text_styles.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/animated_card.dart';
import '../../../data/models/syllabus_model.dart';
import '../../state/syllabus_provider.dart';
import '../../state/topic_progress_provider.dart';
import '../../state/google_classroom_provider.dart';
import 'classroom_detail_page.dart';
import 'chat_page.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  SyllabusModel? _selectedSyllabus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is SyllabusModel) {
      setState(() {
        _selectedSyllabus = args;
      });
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
              _selectedSyllabus?.title ?? AppText.of(context).learning,
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
      body: _selectedSyllabus != null
          ? _buildSubjectContent(_selectedSyllabus!)
          : _buildAllSubjectsView(),
    );
  }

  Widget _buildAllSubjectsView() {
    return Consumer2<SyllabusProvider, GoogleClassroomProvider>(
      builder: (context, syllabusProvider, classroomProvider, child) {
        final syllabi = syllabusProvider.syllabi;
        final classroomCourses = classroomProvider.courses;

        if (syllabusProvider.isLoading || classroomProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (syllabi.isEmpty && classroomCourses.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppText.of(context).noCoursesAvailable,
                    style: TextStyles.headline(context).copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Connect to Google Classroom to import your classes',
                    style: TextStyles.body(context).copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await classroomProvider.signIn();
                      if (classroomProvider.error != null) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(classroomProvider.error!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Connect Google Classroom'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;
            final padding = isSmallScreen ? 16.0 : 24.0;
            final totalCourses = syllabi.length + classroomCourses.length;

            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.school,
                        color: Theme.of(context).colorScheme.primary,
                        size: isSmallScreen ? 28 : 36,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppText.of(context).allSubjects,
                        style: TextStyles.headline(context).copyWith(
                          fontSize: isSmallScreen ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      if (!classroomProvider.isSignedIn)
                        TextButton.icon(
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            await classroomProvider.signIn();
                            if (classroomProvider.error != null) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(classroomProvider.error!),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.login, size: 18),
                          label: const Text('Connect Classroom'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: totalCourses,
                      padding: EdgeInsets.only(bottom: isSmallScreen ? 80 : 24),
                      itemBuilder: (context, index) {
                        if (index < classroomCourses.length) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: isSmallScreen ? 12.0 : 16.0,
                            ),
                            child: _buildGoogleClassroomCard(
                              classroomCourses[index],
                              isSmallScreen,
                            ),
                          );
                        } else {
                          final syllabusIndex = index - classroomCourses.length;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: isSmallScreen ? 12.0 : 16.0,
                            ),
                            child: _buildSubjectCard(
                              syllabi[syllabusIndex],
                              isSmallScreen,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSubjectCard(
    SyllabusModel syllabus, [
    bool isSmallScreen = false,
  ]) {
    final subjectColors = [
      const Color(0xFF1976D2),
      const Color(0xFF388E3C),
      const Color(0xFFD32F2F),
      const Color(0xFFF57C00),
      const Color(0xFF7B1FA2),
      const Color(0xFF0097A7),
    ];
    final colorIndex = syllabus.title.hashCode.abs() % subjectColors.length;
    final subjectColor = subjectColors[colorIndex];

    return AnimatedCard(
      onTap: () {
        setState(() {
          _selectedSyllabus = syllabus;
        });
      },
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: isSmallScreen ? 180 : 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [subjectColor, subjectColor.withValues(alpha: 0.85)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.15,
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: isSmallScreen ? 140 : 160,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      color: Colors.white,
                    ),
                  ),
                  tooltip: 'Ask AI Assistant',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(subject: syllabus.title),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          syllabus.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 22 : 24,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppText.of(
                            context,
                          ).topicsCount(syllabus.topics.length),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: isSmallScreen ? 13 : 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            child: Text(
                              FirebaseAuth.instance.currentUser?.displayName
                                      ?.substring(0, 1)
                                      .toUpperCase() ??
                                  'T',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  'Teacher',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontSize: isSmallScreen ? 13 : 14,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleClassroomCard(
    dynamic course, [
    bool isSmallScreen = false,
  ]) {
    final subjectColors = [
      const Color(0xFF1976D2),
      const Color(0xFF388E3C),
      const Color(0xFFD32F2F),
      const Color(0xFFF57C00),
      const Color(0xFF7B1FA2),
      const Color(0xFF0097A7),
    ];
    final colorIndex = course.name.hashCode.abs() % subjectColors.length;
    final subjectColor = subjectColors[colorIndex];

    return AnimatedCard(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ClassroomDetailPage(course: course),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        );
      },
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: isSmallScreen ? 180 : 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [subjectColor, subjectColor.withValues(alpha: 0.85)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.15,
                  child: Icon(
                    Icons.class_outlined,
                    size: isSmallScreen ? 140 : 160,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Classroom',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      color: Colors.white,
                    ),
                  ),
                  tooltip: 'Ask AI Assistant',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(subject: course.name),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          course.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 22 : 24,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (course.section.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            course.section,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: isSmallScreen ? 13 : 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              course.teacherName,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontSize: isSmallScreen ? 13 : 14,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectContent(SyllabusModel syllabus) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final padding = isSmallScreen ? 16.0 : 24.0;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedSyllabus = null;
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      syllabus.title,
                      style: TextStyles.headline(
                        context,
                      ).copyWith(fontSize: isSmallScreen ? 24 : 32),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              Text(
                syllabus.description,
                style: TextStyles.body(
                  context,
                ).copyWith(fontSize: isSmallScreen ? 14 : 16),
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              // Progress indicator
              Consumer<TopicProgressProvider>(
                builder: (context, progressProvider, child) {
                  final completedCount = progressProvider
                      .getCompletedTopics(syllabus.id)
                      .length;
                  final totalTopics = syllabus.topics.length;
                  final progress = totalTopics > 0
                      ? (completedCount / totalTopics * 100).round()
                      : 0;

                  return Card(
                    color: AppColors.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppText.of(context).progressTitle,
                                style: TextStyles.titleMedium(context),
                              ),
                              Text(
                                '$progress%',
                                style: TextStyles.body(context).copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.2,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppText.of(
                              context,
                            ).completedTopics(completedCount, totalTopics),
                            style: TextStyles.caption(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              Text(
                AppText.of(context).topics,
                style: TextStyles.titleLarge(context),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<TopicProgressProvider>(
                  builder: (context, progressProvider, child) {
                    return ListView.builder(
                      itemCount: syllabus.topics.length,
                      itemBuilder: (context, index) {
                        final topic = syllabus.topics[index];
                        final isCompleted = progressProvider.isTopicCompleted(
                          syllabus.id,
                          topic,
                        );

                        return AnimatedCard(
                          margin: const EdgeInsets.only(bottom: 8),
                          backgroundColor: isCompleted
                              ? AppColors.tertiary.withValues(alpha: 0.1)
                              : null,
                          onTap: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final appText = AppText.of(context, listen: false);
                            try {
                              await progressProvider.toggleTopicCompletion(
                                syllabus.id,
                                topic,
                                !isCompleted,
                              );
                            } catch (e) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('${appText.errorPrefix}: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: isSmallScreen ? 14 : 16,
                              backgroundColor: isCompleted
                                  ? AppColors.tertiary.withValues(alpha: 0.2)
                                  : AppColors.secondary.withValues(alpha: 0.1),
                              child: isCompleted
                                  ? Icon(
                                      Icons.check,
                                      color: AppColors.tertiary,
                                      size: isSmallScreen ? 16 : 18,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: isSmallScreen ? 10 : 12,
                                      ),
                                    ),
                            ),
                            title: Text(
                              topic,
                              style: TextStyles.body(context).copyWith(
                                fontSize: isSmallScreen ? 14 : 16,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isCompleted
                                    ? Theme.of(context).colorScheme.onSurface
                                          .withValues(alpha: 0.6)
                                    : null,
                              ),
                            ),
                            trailing: Checkbox(
                              value: isCompleted,
                              onChanged: (value) async {
                                final messenger = ScaffoldMessenger.of(context);
                                final appText = AppText.of(
                                  context,
                                  listen: false,
                                );
                                try {
                                  await progressProvider.toggleTopicCompletion(
                                    syllabus.id,
                                    topic,
                                    value ?? false,
                                  );
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        value == true
                                            ? appText.topicCompleted
                                            : appText.topicIncomplete,
                                      ),
                                      backgroundColor: value == true
                                          ? Colors.green
                                          : Colors.orange,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } catch (e) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${appText.errorPrefix}: $e',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              activeColor: AppColors.tertiary,
                            ),
                            onTap: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              final appText = AppText.of(
                                context,
                                listen: false,
                              );
                              try {
                                await progressProvider.toggleTopicCompletion(
                                  syllabus.id,
                                  topic,
                                  !isCompleted,
                                );
                              } catch (e) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('${appText.errorPrefix}: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
