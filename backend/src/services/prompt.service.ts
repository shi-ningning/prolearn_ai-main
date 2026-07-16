import { ChatMessage } from '../models/Chat.model';

/**
 * Get subject-specific system prompts for the AI
 */
export function getSystemPrompt(subject?: string): string {
    const basePrompt = `You are a helpful AI assistant for students. You provide clear, accurate, and educational responses.`;
    const normalizedSubject = subject?.toLowerCase();

    if (normalizedSubject === 'general' || !subject) {
        return `${basePrompt} You acting as a "Learning Path Advisor". You have access to the user's entire course list. Analyze their workload, suggest connections between subjects, and help them prioritize their learning across all areas.`;
    }

    const subjectPrompts: Record<string, string> = {
        mathematics: `${basePrompt} You specialize in Mathematics. Help students understand mathematical concepts, solve problems step-by-step, and explain formulas clearly. Use examples when helpful.`,

        science: `${basePrompt} You specialize in Science. Help students understand scientific concepts, explain experiments, and relate theories to real-world applications.`,

        programming: `${basePrompt} You specialize in Programming and Computer Science. Help students understand code, debug issues, explain algorithms, and follow best practices. Provide code examples when appropriate.`,

        english: `${basePrompt} You specialize in English Language and Literature. Help students with grammar, writing, reading comprehension, and literary analysis.`,

        history: `${basePrompt} You specialize in History. Help students understand historical events, their context, causes, and effects. Provide accurate dates and facts.`,

        physics: `${basePrompt} You specialize in Physics. Help students understand physical concepts, solve problems, and explain phenomena with real-world examples.`,

        chemistry: `${basePrompt} You specialize in Chemistry. Help students understand chemical concepts, reactions, and laboratory procedures safely.`,

        biology: `${basePrompt} You specialize in Biology. Help students understand living organisms, biological processes, and life sciences.`,
    };

    return (normalizedSubject && subjectPrompts[normalizedSubject]) || `${basePrompt} You specialize in ${subject}.`;
}

/**
 * Format conversation history for AI context
 */
export function formatConversationHistory(messages: ChatMessage[]): string {
    return messages
        .slice(-10) // Keep last 10 messages for context
        .map(msg => `${msg.isUser ? 'User' : 'Assistant'}: ${msg.message}`)
        .join('\n');
}

/**
 * Get a welcome message for a subject
 */
export function getWelcomeMessage(subject?: string): string {
    if (!subject) {
        return "Hello! I'm your AI assistant. How can I help you today?";
    }

    const welcomeMessages: Record<string, string> = {
        mathematics: `Hello! I'm your Mathematics assistant. I can help you with algebra, calculus, geometry, and more. What would you like to learn?`,
        science: `Hello! I'm your Science assistant. I can help you understand scientific concepts and phenomena. What are you curious about?`,
        programming: `Hello! I'm your Programming assistant. I can help you with code, algorithms, and debugging. What are you working on?`,
        english: `Hello! I'm your English assistant. I can help you with grammar, writing, and literature. What do you need help with?`,
        history: `Hello! I'm your History assistant. I can help you understand historical events and their significance. What period interests you?`,
        physics: `Hello! I'm your Physics assistant. I can help you understand the laws of nature. What would you like to explore?`,
        chemistry: `Hello! I'm your Chemistry assistant. I can help you understand chemical reactions and properties. What are you studying?`,
        biology: `Hello! I'm your Biology assistant. I can help you understand living organisms and life processes. What topic interests you?`,
    };

    const normalizedSubject = subject.toLowerCase();
    return welcomeMessages[normalizedSubject] || `Hello! I'm your ${subject} assistant. How can I help you today?`;
}
