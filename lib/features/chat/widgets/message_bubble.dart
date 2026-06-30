import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../uikit/uikit.dart';
import '../bloc/chat_state.dart';
import 'status_icon.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMine;
  final MessageStatus status;
  final String? errorText;
  final String? time;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMine,
    required this.status,
    this.errorText,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bubbleColor = isMine
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final textColor = isMine
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;
    final metaColor = isMine
        ? theme.colorScheme.onPrimary.withValues(alpha: 0.6)
        : theme.colorScheme.onSurfaceVariant;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * AppBubble.maxWidthFraction,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs / 2),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.m, AppSpacing.s, AppSpacing.m, AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.xl),
            topRight: const Radius.circular(AppRadius.xl),
            bottomLeft: Radius.circular(isMine ? AppRadius.xl : AppSpacing.xs),
            bottomRight:
                Radius.circular(isMine ? AppSpacing.xs : AppRadius.xl),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: AppFontSize.subtitle,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSpacing.xs / 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (time != null)
                  Text(
                    DateFormatter.formatTime(time!),
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: metaColor,
                    ),
                  ),
                if (isMine) ...[
                  const SizedBox(width: AppSpacing.xs),
                  StatusIcon(status: status, color: metaColor),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
