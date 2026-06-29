import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/data.dart';
import 'router/router.dart';
import 'theme/theme.dart';
import 'uikit/uikit.dart';

class App extends StatelessWidget {
  final ChatRepository repository;
  final ThemeController themeController;

  const App({
    super.key,
    required this.repository,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeInherited(
      controller: themeController,
      child: ThemeBuilder(
        controller: themeController,
        builder: (context, mode) => RepositoryProvider.value(
          value: repository,
          child: MaterialApp.router(
            title: 'Realtime Chat',
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.lightTheme,
            darkTheme: AppThemeData.darkTheme,
            themeMode: mode,
            routerConfig: AppRouter.router(repository),
          ),
        ),
      ),
    );
  }
}
