import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: AppAvatarRadius.s,
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.primary,
              child: Text(
                currentUser.name.isNotEmpty
                    ? currentUser.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: AppFontSize.body,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Text(currentUser.name),
          ],
        ),
        actions: const [ThemeButton()],
      ),
      body: BlocBuilder<RoomsBloc, RoomsState>(
        builder: (context, state) {
          return switch (state) {
            RoomsInitial() || RoomsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            RoomsLoaded(:final rooms, :final usersMap) => rooms.isEmpty
                ? const EmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Нет диалогов',
                    subtitle: 'Нажмите + чтобы начать новый чат',
                  )
                : RoomsList(
                    rooms: rooms,
                    usersMap: usersMap,
                    currentUser: currentUser,
                    formatTime: DateFormatter.formatTime,
                  ),
            RoomsError(:final message) => ErrorState(
                title: 'Не удалось загрузить',
                message: message,
                onRetry: () => context
                    .read<RoomsBloc>()
                    .add(RoomsLoadRequested(userId: currentUser.id)),
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewChatSheet(context),
        child: const Icon(Icons.edit_square),
      ),
    );
  }

  void _showNewChatSheet(BuildContext context) {
    final roomsBloc = context.read<RoomsBloc>();
    showModalBottomSheet(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: roomsBloc),
          BlocProvider(
            create: (_) => UsersBloc(
              repository: context.read<ChatRepository>(),
            )..add(const UsersLoadRequested()),
          ),
        ],
        child: NewChatSheet(currentUserId: currentUser.id),
      ),
    );
  }
}
