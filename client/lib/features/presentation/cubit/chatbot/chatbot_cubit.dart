import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/chatbot_entity.dart';
import '../../../domain/usecases/bot/send_bot_message.dart';
part 'chatbot_state.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  final SendBotMessage sendChatMessage;

  ChatBotCubit(this.sendChatMessage) : super(ChatBotState.initial());

  // Future<void> send(String text) async {
  //   emit(
  //     state.copyWith(
  //       messages: [
  //         ...state.messages,
  //         ChatBotEntity.text(isUser: true, text: text),
  //         ChatBotEntity.text(isUser: false, text: "Let me think… 🤔"),
  //       ],
  //       isLoading: true,
  //     ),
  //   );

  //   final aiMessages = await sendChatMessage(text);

  //   emit(
  //     state.copyWith(
  //       messages: [
  //         ...state.messages..removeLast(),
  //         ...aiMessages,
  //       ],
  //       isLoading: false,
  //     ),
  //   );
  // }
  Future<void> send(String text) async {
  emit(
    state.copyWith(
      messages: [
        ...state.messages,
        ChatBotEntity.text(isUser: true, text: text),
        ChatBotEntity.text(isUser: false, text: "Let me think… 🤔"),
      ],
      isLoading: true,
    ),
  );

  final res = await sendChatMessage(text);

  res.fold(
    (failure) {
      emit(
        state.copyWith(
          messages: [
            ...state.messages..removeLast(),
            ChatBotEntity.text(
              isUser: false,
              text: failure.message,
            ),
          ],
          isLoading: false,
        ),
      );
    },
    (aiMessages) {
      emit(
        state.copyWith(
          messages: [
            ...state.messages..removeLast(),
            ...aiMessages,
          ],
          isLoading: false,
        ),
      );
    },
  );
}

  
}
