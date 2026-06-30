import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../uikit/uikit.dart';
import '../bloc/users_bloc.dart';
import '../widgets/widgets.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Chat'),
        actions: const [ThemeButton()],
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return switch (state) {
            UsersInitial() || UsersLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            UsersLoaded(:final users) => users.isEmpty
                ? const EmptyState(
                    icon: Icons.people_outline_rounded,
                    title: 'Добро пожаловать!',
                    subtitle: 'Создайте профиль, чтобы начать общение',
                  )
                : UsersList(users: users),
            UsersError(:final message) => ErrorState(
                title: 'Не удалось подключиться',
                message: message,
                onRetry: () => context
                    .read<UsersBloc>()
                    .add(const UsersLoadRequested()),
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSheet(context),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Новый профиль'),
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const CreateProfileSheet(),
      ),
    );
  }
}
