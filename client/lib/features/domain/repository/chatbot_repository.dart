import 'package:fpdart/fpdart.dart';

import '../../../core/errors/failure.dart';
import '../entity/chatbot_entity.dart';

abstract class ChatBotRepository {
  Future<Either<Failure, List<ChatBotEntity>>> sendMessage(String text);
}
