import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/animated_background.dart';
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
    return Scaffold(
      body: AnimatedBackground(
        showParticles: true,
        child: _buildScaffold(context),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          _selectedSyllabus?.title ?? AppText.learning,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                    color: AppColors.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No courses available',
                    style: TextStyles.headline.copyWith(
                      color: AppColors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Courses are being loaded. Please refresh or check back soon.',
                    style: TextStyles.body.copyWith(
                      color: AppColors.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      syllabusProvider.loadSyllabi();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
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
                  Text(
                    'All Subjects',
                    style: TextStyles.headline.copyWith(
                      fontSize: isSmallScreen ? 24 : 32,
                    ),
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
            style: TextStyles.titleMedium.copyWith(
              fontSize: isSmallScreen ? 16 : 18,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${syllabus.topics.length} topics',
            style: TextStyles.caption,
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
                      style: TextStyles.headline.copyWith(
                        fontSize: isSmallScreen ? 24 : 32,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              Text(
                syllabus.description,
                style: TextStyles.body.copyWith(
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
                                'Progress',
                                style: TextStyles.titleMedium,
                              ),
                              Text(
                                '$progress%',
                                style: TextStyles.body.copyWith(
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
                            '$completedCount of $totalTopics topics completed',
                            style: TextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              Text(
                'Topics',
                style: TextStyles.titleLarge,
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
                              content: Text('Error: $e'),
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
                              style: TextStyles.body.copyWith(
                                fontSize: isSmallScreen ? 14 : 16,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isCompleted
                                    ? AppColors.onSurface.withValues(alpha: 0.6)
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
                                            ? 'Topic marked as completed!'
                                            : 'Topic marked as incomplete',
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
                                      content: Text('Error: $e'),
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
                                    content: Text('Error: $e'),
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
