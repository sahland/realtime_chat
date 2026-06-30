import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../../../domain/domain.dart';
import '../../../uikit/uikit.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final UserModel currentUser;
  final String companionName;

  const ChatPage({
    super.key,
    required this.roomId,
    required this.currentUser,
    required this.companionName,
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
    if (!_scrollController.hasClients) return;
    Future.delayed(AppDuration.scrollDelay, () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppDuration.scrollAnimation,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: ChatAppBarTitle(companionName: widget.companionName),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatReady) _scrollToBottom();
        },
        builder: (context, state) {
          return switch (state) {
            ChatInitial() || ChatLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ChatReady(:final messages) => Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? const EmptyState(
                            icon: Icons.chat_outlined,
                            title: 'Пока пусто',
                            subtitle: 'Напишите первое сообщение',
                          )
                        : MessagesList(
                            messages: messages,
                            currentUserId: widget.currentUser.id,
                            scrollController: _scrollController,
                            isDifferentDay: DateFormatter.isDifferentDay,
                            formatDate: DateFormatter.formatDate,
                          ),
                  ),
                  ChatInput(
                    controller: _textController,
                    onSend: _onSend,
                    onTyping: _onTyping,
                  ),
                ],
              ),
            ChatFailure(:final message) => ErrorState(
                title: 'Ошибка подключения',
                message: message,
                onRetry: () => context.read<ChatBloc>().add(ChatStarted(
                      roomId: widget.roomId,
                      userId: widget.currentUser.id,
                    )),
              ),
          };
        },
      ),
    );
  }
}
