import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/sidebar.dart';
import '../../../data/models/syllabus_model.dart';
import '../../state/syllabus_provider.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _selectedSyllabus?.title ?? AppText.learning,
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        shadowColor: AppColors.shadow,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
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

        if (syllabi.isEmpty) {
          return const Center(
            child: Text('No subjects available', style: TextStyles.body),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSyllabus = syllabus;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: isSmallScreen ? 16 : 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
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
              Text(
                'Topics',
                style: TextStyles.titleLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: syllabus.topics.length,
                  itemBuilder: (context, index) {
                    final topic = syllabus.topics[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: isSmallScreen ? 14 : 16,
                          backgroundColor: AppColors.secondary.withOpacity(0.1),
                          child: Text(
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
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to topic details
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Topic: $topic')),
                          );
                        },
                      ),
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
