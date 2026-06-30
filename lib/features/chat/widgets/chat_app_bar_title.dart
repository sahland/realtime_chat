import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../uikit/uikit.dart';
import '../bloc/chat_bloc.dart';

class ChatAppBarTitle extends StatelessWidget {
  final String companionName;

  const ChatAppBarTitle({super.key, required this.companionName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: AppAvatarRadius.s,
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.primary,
          child: Text(
            companionName.isNotEmpty ? companionName[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: AppFontSize.body,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (prev, curr) {
              if (prev is ChatReady && curr is ChatReady) {
                return prev.isTyping != curr.isTyping;
              }
              return false;
            },
            builder: (context, state) {
              final isTyping = state is ChatReady && state.isTyping;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companionName,
                    style: const TextStyle(
                      fontSize: AppFontSize.title,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedSize(
                    duration: AppDuration.typingAnimation,
                    alignment: Alignment.topLeft,
                    child: isTyping
                        ? Text(
                            'печатает...',
                            style: TextStyle(
                              fontSize: AppFontSize.small,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
