import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/chat_models.dart';
import '../../../data/services/chatbot_service.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/chat_input.dart';
import '../../state/syllabus_provider.dart';
import '../../state/google_classroom_provider.dart';

class ChatPage extends StatefulWidget {
  final String? subject;
  final String? conversationId;

  const ChatPage({super.key, this.subject, this.conversationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late final ChatbotService _chatbotService;
  late final String _conversationId;
  bool _isLoading = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _conversationId =
        widget.conversationId ??
        'conv_${DateTime.now().millisecondsSinceEpoch}';

    // Initialize chatbot service
    _chatbotService = ChatbotService(baseUrl: 'http://localhost:8080');

    _loadChatHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatHistory() async {
    try {
      final history = await _chatbotService.getChatHistory(_conversationId);
      setState(() {
        _messages.addAll(history);
        _isInitializing = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
        _addWelcomeMessage();
      }
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      message: widget.subject != null
          ? 'Hello! I\'m your ${widget.subject} assistant. How can I help you today?'
          : 'Hello! I\'m your AI assistant. How can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
      subject: widget.subject,
    );

    setState(() {
      _messages.add(welcomeMessage);
    });
    _scrollToBottom();
  }

  Future<void> _handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      message: text,
      isUser: true,
      timestamp: DateTime.now(),
      subject: widget.subject,
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      // Get AI response
      final response = await _chatbotService.sendMessage(
        message: text,
        conversationId: _conversationId,
        subject: widget.subject,
      );

      setState(() {
        _messages.add(response);
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        final errorMessage = ChatMessage(
          id: 'error_${DateTime.now().millisecondsSinceEpoch}',
          message: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
          subject: widget.subject,
          isError: true,
        );

        setState(() {
          _messages.add(errorMessage);
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearChat() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text(
          'Are you sure you want to clear this conversation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _chatbotService.clearChatHistory(_conversationId);
        setState(() {
          _messages.clear();
        });
        _addWelcomeMessage();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Failed to clear chat')));
        }
      }
    }
  }

  Future<void> _analyzeLearningPath() async {
    final syllabusProvider = context.read<SyllabusProvider>();
    final classroomProvider = context.read<GoogleClassroomProvider>();

    final syllabiNames = syllabusProvider.syllabi.map((s) => s.title).toList();
    final classroomNames = classroomProvider.courses
        .map((c) => c.name)
        .toList();

    final allSubjects = [...syllabiNames, ...classroomNames];

    if (allSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No subjects found to analyze.')),
      );
      return;
    }

    final analysisRequest =
        "I'd like an overview of my learning path. I am currently enrolled in the following subjects: ${allSubjects.join(', ')}. Please analyze my workload and suggest how I should approach my studies.";

    await _handleSendMessage(analysisRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subject != null ? '${widget.subject} Chat' : 'AI Assistant',
        ),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearChat,
              tooltip: 'Clear chat',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isInitializing
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (widget.subject == null) ...[
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _analyzeLearningPath,
                            icon: const Icon(Icons.analytics_outlined),
                            label: const Text('Analyze My Learning Path'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(
                        message: _messages[index],
                        showTimestamp: true,
                      );
                    },
                  ),
          ),
          ChatInput(
            onSendMessage: _handleSendMessage,
            isLoading: _isLoading,
            hintText: widget.subject != null
                ? 'Ask about ${widget.subject}...'
                : 'Type a message...',
          ),
        ],
      ),
    );
  }
}
