import 'package:flutter/material.dart';

import '../../../uikit/uikit.dart';
import '../bloc/chat_state.dart';

class StatusIcon extends StatelessWidget {
  final MessageStatus status;
  final Color color;

  const StatusIcon({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      MessageStatus.sending => SizedBox(
          width: AppSpacing.m,
          height: AppSpacing.m,
          child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
        ),
      MessageStatus.sent => Icon(
          Icons.done_all,
          size: AppIconSize.m,
          color: color,
        ),
      MessageStatus.error => Icon(
          Icons.error_outline,
          size: AppIconSize.s,
          color: Theme.of(context).colorScheme.error,
        ),
    };
  }
}
