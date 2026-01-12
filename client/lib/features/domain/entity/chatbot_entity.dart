import 'product_view_entity.dart';

enum MessageType {
  text,
  products,
}

class ChatBotEntity {
  final bool isUser;
  final String? text;
  final List<ProductViewEntity>? products;
  final MessageType type;

  ChatBotEntity.text({
    required this.isUser,
    required this.text,
  })  : type = MessageType.text,
        products = null;

  ChatBotEntity.products({
    required this.products,
  })  : type = MessageType.products,
        isUser = false,
        text = null;
}
