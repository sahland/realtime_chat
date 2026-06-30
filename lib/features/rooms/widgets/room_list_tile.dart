import 'package:flutter/material.dart';

import '../../../uikit/uikit.dart';

class RoomListTile extends StatelessWidget {
  final String name;
  final String? lastMessageText;
  final String? lastMessageTime;
  final VoidCallback onTap;

  const RoomListTile({
    super.key,
    required this.name,
    this.lastMessageText,
    this.lastMessageTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: AppAvatarRadius.l,
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.primary,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: AppFontSize.headline,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppFontSize.title,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (lastMessageTime != null)
                        Text(
                          lastMessageTime!,
                          style: TextStyle(
                            fontSize: AppFontSize.body2,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    lastMessageText ?? 'Нет сообщений',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      color: lastMessageText != null
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5),
                      fontStyle: lastMessageText != null
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Icon(
              Icons.chevron_right_rounded,
              size: AppIconSize.l,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
