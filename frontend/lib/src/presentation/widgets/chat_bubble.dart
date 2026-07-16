import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/chat_models.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showTimestamp;

  const ChatBubble({
    super.key,
    required this.message,
    this.showTimestamp = true,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isError = message.isError ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isError
                      ? Colors.red.shade100
                      : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    isError ? Icons.error_outline : Icons.smart_toy,
                    size: 18,
                    color: isError
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Theme.of(context).primaryColor
                        : isError
                        ? Colors.red.shade50
                        : Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : isError
                          ? Colors.red.shade900
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.person,
                    size: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ],
          ),
          if (showTimestamp) ...[
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(
                left: isUser ? 0 : 40,
                right: isUser ? 40 : 0,
              ),
              child: Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE HH:mm').format(timestamp);
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }
}
