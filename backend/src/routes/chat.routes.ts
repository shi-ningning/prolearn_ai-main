import { Router } from 'express';
import { sendMessage, getChatHistory, clearChatHistory } from '../controllers/chat.controller';

const router = Router();

// Send a message and get AI response
router.post('/message', sendMessage);

// Get chat history for a conversation
router.get('/history/:conversationId', getChatHistory);

// Clear chat history for a conversation
router.delete('/history/:conversationId', clearChatHistory);

export default router;
