import { GoogleGenerativeAI } from '@google/generative-ai';
import OpenAI from 'openai';
import { ChatMessage } from '../models/Chat.model';
import { getSystemPrompt, formatConversationHistory } from './prompt.service';

// AI Provider configuration
const AI_PROVIDER = process.env.AI_PROVIDER || 'gemini';

// Initialize AI clients
let geminiClient: GoogleGenerativeAI | null = null;
let openaiClient: OpenAI | null = null;

if (AI_PROVIDER === 'gemini' && process.env.GEMINI_API_KEY) {
    geminiClient = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
} else if (AI_PROVIDER === 'openai' && process.env.OPENAI_API_KEY) {
    openaiClient = new OpenAI({
        apiKey: process.env.OPENAI_API_KEY,
    });
}

/**
 * Generates an AI response using the configured provider.
 * @param message The user's message.
 * @param conversationHistory Previous messages for context.
 * @param subject The subject/context for the AI.
 * @returns A ChatMessage containing the AI's response.
 */
export async function generateAIResponse(
    message: string,
    conversationHistory: ChatMessage[],
    subject?: string
): Promise<ChatMessage> {
    try {
        let responseText: string;

        if (AI_PROVIDER === 'gemini') {
            responseText = await generateGeminiResponse(message, conversationHistory, subject);
        } else if (AI_PROVIDER === 'openai') {
            responseText = await generateOpenAIResponse(message, conversationHistory, subject);
        } else {
            throw new Error(`Unsupported AI provider: ${AI_PROVIDER}`);
        }

        return {
            id: `ai_${Date.now()}`,
            message: responseText,
            isUser: false,
            timestamp: new Date(),
            subject,
        };
    } catch (error: any) {
        console.error('AI generation error:', error);

        // Handle Quota exceeded
        if (error.message?.includes('429')) {
            return {
                id: `error_${Date.now()}`,
                message: 'I have reached my free limit for now. Please wait a minute before trying again, or check if your Gemini billing is set up.',
                isUser: false,
                timestamp: new Date(),
                subject,
                isError: true,
            };
        }

        return {
            id: `error_${Date.now()}`,
            message: 'Sorry, I encountered an error processing your request. Please try again.',
            isUser: false,
            timestamp: new Date(),
            subject,
            isError: true,
        };
    }
}

async function generateGeminiResponse(
    message: string,
    conversationHistory: ChatMessage[],
    subject?: string
): Promise<string> {
    if (!geminiClient) {
        throw new Error('Gemini API key not configured');
    }

    // Use gemini-2.0-flash as it was verified by the user via curl
    const model = geminiClient.getGenerativeModel({ model: 'gemini-2.0-flash' });
    const systemPrompt = getSystemPrompt(subject);
    const history = formatConversationHistory(conversationHistory);

    const prompt = `${systemPrompt}\n\nPrevious conversation:\n${history}\n\nUser: ${message}\n\nAssistant:`;

    const result = await model.generateContent(prompt);
    const response = await result.response;
    return response.text();
}

async function generateOpenAIResponse(
    message: string,
    conversationHistory: ChatMessage[],
    subject?: string
): Promise<string> {
    if (!openaiClient) {
        throw new Error('OpenAI API key not configured');
    }

    const systemPrompt = getSystemPrompt(subject);
    const messages: OpenAI.Chat.ChatCompletionMessageParam[] = [
        { role: 'system', content: systemPrompt },
        ...conversationHistory.slice(-10).map(msg => ({
            role: (msg.isUser ? 'user' : 'assistant') as 'user' | 'assistant',
            content: msg.message,
        })),
        { role: 'user', content: message },
    ];

    const completion = await openaiClient.chat.completions.create({
        model: 'gpt-3.5-turbo',
        messages,
        temperature: 0.7,
        max_tokens: 1000,
    });

    return completion.choices[0]?.message?.content || 'No response generated';
}
