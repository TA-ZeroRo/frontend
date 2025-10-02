import 'package:go_router/go_router.dart';

import '../screens/entry/login_screen.dart';
import '../screens/entry/splash_screen.dart';
import '../screens/main/main_screen.dart';
import 'router_path.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePath.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePath.main,
      name: 'main',
      builder: (context, state) => MainScreen(),
    ),
  ],
  initialLocation: RoutePath.splash,
);
