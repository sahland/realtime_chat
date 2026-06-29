import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../uikit/uikit.dart';
import '../../users/users.dart';
import '../bloc/rooms_bloc.dart';
import '../widgets/widgets.dart';

class RoomsPage extends StatelessWidget {
  final UserModel currentUser;

  const RoomsPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser.name),
        actions: const [ThemeButton()],
      ),
      body: BlocBuilder<RoomsBloc, RoomsState>(
        builder: (context, state) {
          return switch (state) {
            RoomsInitial() || RoomsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            RoomsLoaded(:final rooms) => rooms.isEmpty
                ? _buildEmpty(context)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: rooms.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      final companionId = room.userAId == currentUser.id
                          ? room.userBId
                          : room.userAId;

                      return RoomListTile(
                        companionId: companionId,
                        lastMessageText: room.lastMessage?.text,
                        onTap: () => context.go(
                          '/rooms/${room.id}',
                          extra: {
                            'currentUser': currentUser,
                            'roomId': room.id,
                          },
                        ),
                      );
                    },
                  ),
            RoomsError(:final message) => Center(
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
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context
                            .read<RoomsBloc>()
                            .add(RoomsLoadRequested(userId: currentUser.id)),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChatDialog(context),
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Нет диалогов',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Начните новый чат',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showNewChatDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BlocProvider(
        create: (_) => UsersBloc(
          repository: context.read<ChatRepository>(),
        )..add(const UsersLoadRequested()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Выберите собеседника',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Flexible(
              child: BlocBuilder<UsersBloc, UsersState>(
                builder: (blocContext, state) {
                  return switch (state) {
                    UsersInitial() || UsersLoading() => const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    UsersLoaded(:final users) => ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: users.length,
                        itemBuilder: (_, index) {
                          final user = users[index];
                          if (user.id == currentUser.id) {
                            return const SizedBox.shrink();
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              child: Text(
                                user.name[0].toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            title: Text(user.name),
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              context
                                  .read<RoomsBloc>()
                                  .add(RoomCreateRequested(
                                    currentUserId: currentUser.id,
                                    targetUserId: user.id,
                                  ));
                            },
                          );
                        },
                      ),
                    UsersError() => const SizedBox(
                        height: 200,
                        child: Center(child: Text('Ошибка загрузки')),
                      ),
                  };
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
