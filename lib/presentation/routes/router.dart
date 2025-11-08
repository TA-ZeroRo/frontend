import 'package:go_router/go_router.dart';

import '../screens/campaign/campaign_recruiting_screen.dart';
import '../screens/entry/login_screen.dart';
import '../screens/entry/register_screen.dart';
import '../screens/entry/splash_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/settings/settings_screen.dart';
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
      path: RoutePath.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RoutePath.main,
      name: 'main',
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: RoutePath.campaignRecruiting,
      name: 'campaignRecruiting',
      builder: (context, state) => const CampaignRecruitingScreen(),
    ),
    GoRoute(
      path: RoutePath.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  initialLocation: RoutePath.splash,
);
