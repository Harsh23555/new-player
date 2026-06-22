import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../features/settings/providers/settings_provider.dart';

class NovaPlayerApp extends ConsumerWidget {
  const NovaPlayerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isAmoled = ref.watch(isAmoledProvider);

    Animate.restartOnHotReload = true;

    return MaterialApp.router(
      title: 'Nova Player',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: isAmoled ? AppTheme.amoledTheme : AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
