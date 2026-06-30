import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/data.dart';
import '../domain/domain.dart';
import '../features/features.dart';

class AppRouter {
  static GoRouter router(ChatRepository repository) => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider(
              create: (_) =>
                  UsersBloc(repository: repository)
                    ..add(const UsersLoadRequested()),
              child: const UsersPage(),
            ),
          ),
          GoRoute(
            path: '/rooms',
            builder: (context, state) {
              final user = state.extra! as UserModel;
              return BlocProvider(
                create: (_) =>
                    RoomsBloc(repository: repository)
                      ..add(RoomsLoadRequested(userId: user.id)),
                child: RoomsPage(currentUser: user),
              );
            },
          ),
          GoRoute(
            path: '/rooms/:roomId',
            builder: (context, state) {
              final extra = state.extra! as Map<String, dynamic>;
              final currentUser = extra['currentUser'] as UserModel;
              final roomId = state.pathParameters['roomId']!;
              final companionName =
                  extra['companionName'] as String? ?? 'Чат';

              return BlocProvider(
                create: (_) =>
                    ChatBloc(repository: repository)
                      ..add(ChatStarted(
                        roomId: roomId,
                        userId: currentUser.id,
                      )),
                child: ChatPage(
                  roomId: roomId,
                  currentUser: currentUser,
                  companionName: companionName,
                ),
              );
            },
          ),
        ],
      );
}
