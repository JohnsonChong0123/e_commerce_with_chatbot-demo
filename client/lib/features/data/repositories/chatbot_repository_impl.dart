import 'package:fpdart/fpdart.dart';

import '../../../core/errors/exception.dart';
import '../../../core/errors/failure.dart';
import '../../domain/entity/chatbot_entity.dart';
import '../../domain/entity/product_view_entity.dart';
import '../../domain/repository/chatbot_repository.dart';
import '../sources/remote/chatbot_remote_data.dart';

class ChatBotRepositoryImpl implements ChatBotRepository {
  final ChatBotRemoteData chatbotRemoteData;

  ChatBotRepositoryImpl(this.chatbotRemoteData);

  @override
  Future<Either<Failure, List<ChatBotEntity>>> sendMessage(String text) async {
    try {
      final data = await chatbotRemoteData.send(text);

      final result = <ChatBotEntity>[
        ChatBotEntity.text(isUser: false, text: data["reply"]),
      ];

      if (data["products"] != null && data["products"].isNotEmpty) {
        result.add(
          ChatBotEntity.products(
            products: (data["products"] as List).map((p) {
              return ProductViewEntity(
                name: p["title"],
                overview: p["description"] ?? '',
                productPrice: p["final_prices"] ?? 0.0,
                initialPrice: p["initial_prices"] ?? 0.0,
                image: p["image_url"],
                rating: p["rating"] ?? '',
                reviewsCount: p["reviews_count"] ?? '',
                productId: p["asin"],
              );
            }).toList(),
          ),
        );
      }

      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
