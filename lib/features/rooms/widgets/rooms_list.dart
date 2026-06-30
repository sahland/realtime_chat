import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';
import '../../../domain/domain.dart';
import '../../../uikit/uikit.dart';
import 'room_list_tile.dart';

class RoomsList extends StatelessWidget {
  final List<RoomModel> rooms;
  final Map<String, UserModel> usersMap;
  final UserModel currentUser;
  final String Function(String) formatTime;

  const RoomsList({
    super.key,
    required this.rooms,
    required this.usersMap,
    required this.currentUser,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      itemCount: rooms.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        indent: AppSpacing.dividerIndent,
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      itemBuilder: (context, index) {
        final room = rooms[index];
        final companionId = room.userAId == currentUser.id
            ? room.userBId
            : room.userAId;
        final companion = usersMap[companionId];
        final name = companion?.name ?? 'Неизвестный';

        return RoomListTile(
          name: name,
          lastMessageText: room.lastMessage?.text,
          lastMessageTime: room.lastMessage != null
              ? DateFormatter.formatTime(room.lastMessage!.createdAt)
              : null,
          onTap: () => context.push(
            '/rooms/${room.id}',
            extra: {
              'currentUser': currentUser,
              'roomId': room.id,
              'companionName': name,
            },
          ),
        );
      },
    );
  }
}
