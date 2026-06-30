import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'data/data.dart';
import 'router/router.dart';
import 'theme/theme.dart';
import 'uikit/uikit.dart';

class App extends StatefulWidget {
  final ChatRepository repository;
  final ThemeController themeController;

  const App({
    super.key,
    required this.repository,
    required this.themeController,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.router(widget.repository);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeInherited(
      controller: widget.themeController,
      child: ThemeBuilder(
        controller: widget.themeController,
        builder: (context, mode) => RepositoryProvider.value(
          value: widget.repository,
          child: MaterialApp.router(
            title: 'Realtime Chat',
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.lightTheme,
            darkTheme: AppThemeData.darkTheme,
            themeMode: mode,
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}
