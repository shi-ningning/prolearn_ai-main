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
                color: colorScheme.onSurface.withOpacity(0.6),
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
                    FirebaseAuth.instance.currentUser?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
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
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
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
    return Consumer<SyllabusProvider>(
      builder: (context, syllabusProvider, child) {
        final syllabi = syllabusProvider.syllabi;

        if (syllabusProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (syllabi.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 80,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppText.of(context).noCoursesAvailable,
                    style: TextStyles.headline(context).copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppText.of(context).coursesLoading,
                    style: TextStyles.body(context).copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      syllabusProvider.loadSyllabi();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(AppText.of(context).refresh),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
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
            final crossAxisCount = isSmallScreen ? 1 : 2;
            final padding = isSmallScreen ? 16.0 : 24.0;
            final spacing = isSmallScreen ? 12.0 : 16.0;

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
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: isSmallScreen ? 2.5 : 1.2,
                      ),
                      itemCount: syllabi.length,
                      itemBuilder: (context, index) {
                        final syllabus = syllabi[index];
                        return _buildSubjectCard(syllabus, isSmallScreen);
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

  Widget _buildSubjectCard(SyllabusModel syllabus, [bool isSmallScreen = false]) {
    return AnimatedCard(
      onTap: () {
        setState(() {
          _selectedSyllabus = syllabus;
        });
      },
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: isSmallScreen ? 16 : 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              syllabus.title.isNotEmpty ? syllabus.title[0].toUpperCase() : 'S',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            syllabus.title,
            style: TextStyles.titleMedium(context).copyWith(
              fontSize: isSmallScreen ? 16 : 18,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            AppText.of(context).topicsCount(syllabus.topics.length),
            style: TextStyles.caption(context),
          ),
        ],
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
                      style: TextStyles.headline(context).copyWith(
                        fontSize: isSmallScreen ? 24 : 32,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              Text(
                syllabus.description,
                style: TextStyles.body(context).copyWith(
                  fontSize: isSmallScreen ? 14 : 16,
                ),
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
                            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppText.of(context)
                                .completedTopics(completedCount, totalTopics),
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
                        // Toggle completion on tap
                        try {
                          await progressProvider.toggleTopicCompletion(
                            syllabus.id,
                            topic,
                            !isCompleted,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${AppText.of(context, listen: false).errorPrefix}: $e',
                              ),
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
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6)
                                    : null,
                              ),
                            ),
                            trailing: Checkbox(
                              value: isCompleted,
                              onChanged: (value) async {
                                try {
                                  await progressProvider.toggleTopicCompletion(
                                    syllabus.id,
                                    topic,
                                    value ?? false,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        value == true
                                            ? AppText.of(context, listen: false)
                                                .topicCompleted
                                            : AppText.of(context, listen: false)
                                                .topicIncomplete,
                                      ),
                                      backgroundColor: value == true
                                          ? Colors.green
                                          : Colors.orange,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${AppText.of(context, listen: false).errorPrefix}: $e',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              activeColor: AppColors.tertiary,
                            ),
                            onTap: () async {
                              // Toggle completion on tap
                              try {
                                await progressProvider.toggleTopicCompletion(
                                  syllabus.id,
                                  topic,
                                  !isCompleted,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${AppText.of(context, listen: false).errorPrefix}: $e',
                                    ),
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
