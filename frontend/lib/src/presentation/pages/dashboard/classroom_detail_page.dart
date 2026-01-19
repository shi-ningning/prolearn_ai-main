import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/services/google_classroom_service.dart';
import '../../state/google_classroom_provider.dart';
import '../../widgets/animated_card.dart';
import 'assignment_detail_page.dart';

class ClassroomDetailPage extends StatefulWidget {
  final GoogleClassroomCourse course;

  const ClassroomDetailPage({
    super.key,
    required this.course,
  });

  @override
  State<ClassroomDetailPage> createState() => _ClassroomDetailPageState();
}

class _ClassroomDetailPageState extends State<ClassroomDetailPage> {
  int _selectedIndex = 0;
  List<GoogleClassroomAnnouncement> _announcements = [];
  List<GoogleClassroomAssignment> _assignments = [];
  List<GoogleClassroomCourseMaterial> _materials = [];
  List<GoogleClassroomTopic> _topics = [];
  Map<String, String> _teacherNames = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllContent();
  }

  Future<void> _loadAllContent() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<GoogleClassroomProvider>();
      
      final results = await Future.wait([
        provider.getAnnouncements(widget.course.id),
        provider.getCourseWork(widget.course.id),
        provider.getCourseMaterials(widget.course.id),
        provider.getTopics(widget.course.id),
      ]);
      
      final announcements = results[0] as List<GoogleClassroomAnnouncement>;
      
      final teacherIds = announcements
          .map((a) => a.creatorUserId)
          .where((id) => id.isNotEmpty)
          .toSet();
      
      final teacherNamesFutures = teacherIds.map((userId) async {
        final name = await provider.getTeacherName(widget.course.id, userId);
        return MapEntry(userId, name);
      });
      
      final teacherNamesResults = await Future.wait(teacherNamesFutures);
      final teacherNamesMap = Map.fromEntries(teacherNamesResults);
      
      setState(() {
        _announcements = announcements;
        _assignments = results[1] as List<GoogleClassroomAssignment>;
        _materials = results[2] as List<GoogleClassroomCourseMaterial>;
        _topics = results[3] as List<GoogleClassroomTopic>;
        _teacherNames = teacherNamesMap;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading content: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          _buildCourseHeader(colorScheme),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : IndexedStack(
                    index: _selectedIndex,
                    children: [
                      _buildStreamTab(colorScheme),
                      _buildClassworkTab(colorScheme),
                      _buildPeopleTab(colorScheme),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Stream',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Classwork',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'People',
          ),
        ],
      ),
    );
  }

  Widget _buildCourseHeader(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1976D2),
            const Color(0xFF1565C0),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.videocam_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.course.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.edit_outlined,
                        color: Colors.white.withOpacity(0.9),
                        size: 20,
                      ),
                    ],
                  ),
                  if (widget.course.section.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.course.section,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Icon(
                    Icons.class_outlined,
                    color: Colors.white.withOpacity(0.7),
                    size: 64,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamTab(ColorScheme colorScheme) {
    return RefreshIndicator(
      onRefresh: _loadAllContent,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNewAnnouncementButton(colorScheme),
          const SizedBox(height: 16),
          if (_announcements.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.announcement_outlined,
                      size: 64,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No announcements yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._announcements.map((announcement) =>
                _buildStreamAnnouncementCard(announcement, colorScheme)),
        ],
      ),
    );
  }

  Widget _buildNewAnnouncementButton(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'New announcement',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreamAnnouncementCard(
    GoogleClassroomAnnouncement announcement,
    ColorScheme colorScheme,
  ) {
    final teacherName = _teacherNames[announcement.creatorUserId] ?? 'Teacher';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacherName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        _formatDate(announcement.creationTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              announcement.text,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            if (announcement.materials.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...announcement.materials.map((material) =>
                  _buildMaterialChip(material, colorScheme)),
            ],
            const SizedBox(height: 16),
            Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.1)),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Add class comment',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialChip(
    GoogleClassroomMaterial material,
    ColorScheme colorScheme,
  ) {
    IconData icon;
    String label;
    String? link;
    Color backgroundColor;
    Color iconColor;
    Color textColor;

    final isDark = colorScheme.brightness == Brightness.dark;

    if (material.driveFile != null) {
      icon = Icons.description;
      label = material.driveFile!;
      link = null;
      backgroundColor = isDark ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade50;
      iconColor = isDark ? Colors.red.shade300 : Colors.red.shade700;
      textColor = colorScheme.onSurface;
    } else if (material.youtubeVideo != null) {
      icon = Icons.video_library;
      label = material.youtubeVideo!;
      link = null;
      backgroundColor = isDark ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade50;
      iconColor = isDark ? Colors.red.shade300 : Colors.red.shade700;
      textColor = colorScheme.onSurface;
    } else if (material.link != null) {
      icon = Icons.link;
      label = material.link!;
      link = material.link;
      backgroundColor = isDark ? Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50;
      iconColor = isDark ? Colors.blue.shade300 : Colors.blue.shade700;
      textColor = colorScheme.onSurface;
    } else if (material.form != null) {
      icon = Icons.assignment;
      label = material.form!;
      link = null;
      backgroundColor = isDark ? Colors.purple.shade900.withOpacity(0.3) : Colors.purple.shade50;
      iconColor = isDark ? Colors.purple.shade300 : Colors.purple.shade700;
      textColor = colorScheme.onSurface;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? iconColor.withOpacity(0.3) : colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: link != null ? () => _launchUrl(link!) : null,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassworkTab(ColorScheme colorScheme) {
    final allWork = [
      ..._assignments,
      ..._materials,
    ];

    if (allWork.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No classwork yet',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_topics.isNotEmpty) ...[
          ..._topics.map((topic) => _buildTopicHeader(topic, colorScheme)),
          const SizedBox(height: 16),
        ],
        ..._assignments
            .map((assignment) => _buildAssignmentCard(assignment, colorScheme)),
        ..._materials
            .map((material) => _buildCourseMaterialCard(material, colorScheme)),
      ],
    );
  }

  Widget _buildTopicHeader(GoogleClassroomTopic topic, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              topic.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(
    GoogleClassroomAssignment assignment,
    ColorScheme colorScheme,
  ) {
    final now = DateTime.now();
    final isOverdue = assignment.dueDate != null &&
        assignment.dueDate!.isBefore(now) &&
        assignment.state != 'TURNED_IN';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AssignmentDetailPage(assignment: assignment),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isOverdue
                      ? Colors.red.shade50
                      : colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment,
                  color: isOverdue ? Colors.red : colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (assignment.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Due ${_formatDate(assignment.dueDate!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue
                              ? Colors.red
                              : colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseMaterialCard(
    GoogleClassroomCourseMaterial material,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description,
                  color: colorScheme.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Posted ${_formatDate(material.creationTime)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeopleTab(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'People view coming soon',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
