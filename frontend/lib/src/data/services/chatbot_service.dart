import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_models.dart';

class ChatbotService {
  final String baseUrl;
  final String? apiKey;

  ChatbotService({required this.baseUrl, this.apiKey});

  /// Send a message to the chatbot and get a response
  Future<ChatMessage> sendMessage({
    required String message,
    required String conversationId,
    String? subject,
    String? userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat/message'),
        headers: {
          'Content-Type': 'application/json',
          if (apiKey != null) 'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'message': message,
          'conversationId': conversationId,
          'subject': subject,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatMessage.fromJson(data['response']);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  /// Get chat history for a conversation
  Future<List<ChatMessage>> getChatHistory(String conversationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/chat/history/$conversationId'),
        headers: {if (apiKey != null) 'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final messages = (data['messages'] as List)
            .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList();
        return messages;
      } else {
        throw Exception('Failed to get chat history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting chat history: $e');
    }
  }

  /// Clear chat history for a conversation
  Future<void> clearChatHistory(String conversationId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/chat/history/$conversationId'),
        headers: {if (apiKey != null) 'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to clear chat history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error clearing chat history: $e');
    }
  }

  /// Stream messages (for real-time updates if needed)
  Stream<ChatMessage> streamMessages({
    required String message,
    required String conversationId,
    String? subject,
    String? userId,
  }) async* {
    try {
      // User message
      yield ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        isUser: true,
        timestamp: DateTime.now(),
        subject: subject,
      );

      // AI response
      final response = await sendMessage(
        message: message,
        conversationId: conversationId,
        subject: subject,
        userId: userId,
      );

      yield response;
    } catch (e) {
      yield ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'Error: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
        subject: subject,
        isError: true,
      );
    }
  }
}
