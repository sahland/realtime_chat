import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../uikit/uikit.dart';
import '../../users/users.dart';
import '../bloc/rooms_bloc.dart';

class NewChatSheet extends StatelessWidget {
  final String currentUserId;

  const NewChatSheet({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.m),
        const BottomSheetHandle(),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Text(
            'Новый диалог',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Flexible(
          child: BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              return switch (state) {
                UsersInitial() || UsersLoading() => const SizedBox(
                    height: AppSpacing.sheetMinHeight,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                UsersLoaded(:final users) => ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
                    itemCount: users.length,
                    itemBuilder: (_, index) {
                      final user = users[index];
                      if (user.id == currentUserId) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.primary,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        title: Text(user.name),
                        onTap: () {
                          Navigator.of(context).pop();
                          context
                              .read<RoomsBloc>()
                              .add(RoomCreateRequested(
                                currentUserId: currentUserId,
                                targetUserId: user.id,
                              ));
                        },
                      );
                    },
                  ),
                UsersError() => const SizedBox(
                    height: AppSpacing.sheetMinHeight,
                    child: Center(child: Text('Ошибка загрузки')),
                  ),
              };
            },
          ),
        ),
      ],
    );
  }
}
