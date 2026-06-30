import 'package:flutter/material.dart';

import '../../../uikit/uikit.dart';
import '../bloc/chat_state.dart';
import 'date_separator.dart';
import 'message_bubble.dart';

class MessagesList extends StatelessWidget {
  final List<ChatMessage> messages;
  final String currentUserId;
  final ScrollController scrollController;
  final bool Function(String?, String?) isDifferentDay;
  final String Function(String) formatDate;

  const MessagesList({
    super.key,
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
    required this.isDifferentDay,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isMine = msg.senderId == currentUserId;
        final prevTime =
            index > 0 ? messages[index - 1].message?.createdAt : null;
        final currTime = msg.message?.createdAt;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDifferentDay(prevTime, currTime) && currTime != null)
              DateSeparator(label: formatDate(currTime)),
            MessageBubble(
              text: msg.text,
              isMine: isMine,
              status: msg.status,
              errorText: msg.errorText,
              time: msg.message?.createdAt,
            ),
          ],
        );
      },
    );
  }
}
