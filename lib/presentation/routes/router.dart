import 'package:go_router/go_router.dart';

import '../screens/main/main_screen.dart';
import 'router_path.dart';
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.main,
      name: 'main',
      builder: (context, state) => MainScreen(),
    )
  ],
  initialLocation: RoutePath.main,
);
