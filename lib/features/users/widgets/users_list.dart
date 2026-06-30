import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/domain.dart';
import '../../../uikit/uikit.dart';
import 'user_card.dart';

class UsersList extends StatelessWidget {
  final List<UserModel> users;

  const UsersList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Войти как',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Выберите профиль или создайте новый',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: AppFontSize.subtitle,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          sliver: SliverList.separated(
            itemCount: users.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s),
            itemBuilder: (context, index) {
              final user = users[index];
              return UserCard(
                name: user.name,
                onTap: () => context.push('/rooms', extra: user),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.listBottomInset),
        ),
      ],
    );
  }
}
