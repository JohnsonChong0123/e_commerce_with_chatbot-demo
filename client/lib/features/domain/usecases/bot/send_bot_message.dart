import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../entity/chatbot_entity.dart';
import '../../repository/chatbot_repository.dart';

class SendBotMessage {
  final ChatBotRepository repository;

  SendBotMessage(this.repository);

  Future<Either<Failure, List<ChatBotEntity>>> call(String text) {
    return repository.sendMessage(text);
  }
}
