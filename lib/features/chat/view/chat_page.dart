import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';
import '../../../uikit/uikit.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final UserModel currentUser;

  const ChatPage({
    super.key,
    required this.roomId,
    required this.currentUser,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(ChatMessageSent(text: text));
    _textController.clear();
  }

  void _onTyping() {
    context.read<ChatBloc>().add(const ChatTypingSent());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чат'),
        actions: const [ThemeButton()],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatReady) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          return switch (state) {
            ChatInitial() || ChatLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ChatReady(:final messages, :final isTyping) => Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.message_outlined,
                                  size: 64,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Напишите первое сообщение',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              final isMine =
                                  msg.senderId == widget.currentUser.id;
                              return MessageBubble(
                                text: msg.text,
                                isMine: isMine,
                                status: msg.status,
                                errorText: msg.errorText,
                              );
                            },
                          ),
                  ),
                  if (isTyping) const TypingIndicator(),
                  ChatInput(
                    controller: _textController,
                    onSend: _onSend,
                    onTyping: _onTyping,
                  ),
                ],
              ),
            ChatFailure(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(message, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
          };
        },
      ),
    );
  }
}
