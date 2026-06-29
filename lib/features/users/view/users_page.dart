import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/users_bloc.dart';
import '../widgets/widgets.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выберите пользователя')),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return switch (state) {
            UsersInitial() || UsersLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            UsersLoaded(:final users) => users.isEmpty
                ? const Center(child: Text('Нет пользователей'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: users.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserListTile(
                        name: user.name,
                        onTap: () => context.go('/rooms', extra: user),
                      );
                    },
                  ),
            UsersError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<UsersBloc>()
                          .add(const UsersLoadRequested()),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новый пользователь'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Имя'),
          onSubmitted: (_) {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              context
                  .read<UsersBloc>()
                  .add(UserCreateRequested(name: name));
              Navigator.of(dialogContext).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context
                    .read<UsersBloc>()
                    .add(UserCreateRequested(name: name));
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }
}
