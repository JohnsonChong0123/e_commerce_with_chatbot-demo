part of 'chatbot_cubit.dart';

class ChatBotState {
  final List<ChatBotEntity> messages;
  final bool isLoading;

  ChatBotState({
    required this.messages,
    required this.isLoading,
  });

  factory ChatBotState.initial() {
    return ChatBotState(messages: [], isLoading: false);
  }

  ChatBotState copyWith({
    List<ChatBotEntity>? messages,
    bool? isLoading,
  }) {
    return ChatBotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
