import 'package:flutter/material.dart';

class RoomListTile extends StatelessWidget {
  final String companionId;
  final String? lastMessageText;
  final VoidCallback onTap;

  const RoomListTile({
    super.key,
    required this.companionId,
    this.lastMessageText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(companionId.substring(0, 2).toUpperCase()),
        ),
        title: Text(companionId),
        subtitle: lastMessageText != null
            ? Text(
                lastMessageText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
