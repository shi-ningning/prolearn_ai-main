import { Request, Response } from 'express';
import { ChatMessage, ChatRequest, ChatResponse } from '../models/Chat.model';
import { generateAIResponse } from '../services/ai.service';

// In-memory storage for conversations (replace with database in production)
const conversations = new Map<string, ChatMessage[]>();

export const sendMessage = async (req: Request, res: Response): Promise<void> => {
    try {
        const { message, conversationId, subject, userId }: ChatRequest = req.body;

        if (!message || !conversationId) {
            res.status(400).json({ error: 'Message and conversationId are required' });
            return;
        }

        // Get or create conversation history
        const history = conversations.get(conversationId) || [];

        // Add user message to history
        const userMessage: ChatMessage = {
            id: `user_${Date.now()}`,
            message,
            isUser: true,
            timestamp: new Date(),
            subject,
        };
        history.push(userMessage);

        // Generate AI response
        const aiResponse = await generateAIResponse(message, history, subject);
        history.push(aiResponse);

        // Save updated conversation
        conversations.set(conversationId, history);

        const response: ChatResponse = {
            response: aiResponse,
            conversationId,
        };

        res.status(200).json(response);
    } catch (error) {
        console.error('Error in sendMessage:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const getChatHistory = async (req: Request, res: Response): Promise<void> => {
    try {
        const { conversationId } = req.params;

        if (!conversationId) {
            res.status(400).json({ error: 'Conversation ID is required' });
            return;
        }

        const messages = conversations.get(conversationId) || [];

        res.status(200).json({ messages });
    } catch (error) {
        console.error('Error in getChatHistory:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const clearChatHistory = async (req: Request, res: Response): Promise<void> => {
    try {
        const { conversationId } = req.params;

        if (!conversationId) {
            res.status(400).json({ error: 'Conversation ID is required' });
            return;
        }

        conversations.delete(conversationId);

        res.status(200).json({ message: 'Chat history cleared successfully' });
    } catch (error) {
        console.error('Error in clearChatHistory:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};
