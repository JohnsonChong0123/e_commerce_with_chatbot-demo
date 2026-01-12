import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../domain/entity/chatbot_entity.dart';
import '../../../domain/entity/product_view_entity.dart';
import '../../cubit/chatbot/chatbot_cubit.dart';
import '../../widgets/product_card.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  static route() => MaterialPageRoute(builder: (_) => const ChatBotScreen());

  @override
  State<ChatBotScreen> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBotCubit>().send(text);
    _controller.clear();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Shopping Assistant")),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBotCubit, ChatBotState>(
              listener: (context, state) => _scrollToBottom(),
              builder: (context, state) {
                if (state.messages.isEmpty) {
                  return const _EmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];

                    switch (message.type) {
                      case MessageType.text:
                        return _TextBubble(message: message);
                      case MessageType.products:
                        return _ProductList(products: message.products!);
                    }
                  },
                );
              },
            ),
          ),

          _InputBar(controller: _controller, onSend: _send),
        ],
      ),
    );
  }
}

class _TextBubble extends StatelessWidget {
  final ChatBotEntity message;

  const _TextBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text ?? '',
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  final List<ProductViewEntity> products;

  const _ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "What are you looking for?",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: AppColor.green),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "👋 Hi! You can try searching things like: \n• Cheap sports shoes\n• Men's shoes for office wear\n• Running shoes below RM200",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
