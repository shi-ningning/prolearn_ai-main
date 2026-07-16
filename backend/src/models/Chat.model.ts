export interface ChatMessage {
    id: string;
    message: string;
    isUser: boolean;
    timestamp: Date;
    subject?: string;
    isError?: boolean;
}

export interface ChatConversation {
    id: string;
    userId: string;
    subject?: string;
    messages: ChatMessage[];
    createdAt: Date;
    updatedAt: Date;
}

export interface ChatRequest {
    message: string;
    conversationId: string;
    subject?: string;
    userId?: string;
}

export interface ChatResponse {
    response: ChatMessage;
    conversationId: string;
}
