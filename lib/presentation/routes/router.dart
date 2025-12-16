import 'package:go_router/go_router.dart';

import '../screens/entry/login_screen.dart';
import '../screens/entry/register_screen.dart';
import '../screens/entry/splash_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/main/pages/recruiting/recruiting_detail_screen.dart';
import '../screens/main/pages/campaign/models/recruiting_post.dart';
import '../screens/main/pages/campaign/models/campaign_data.dart';
import '../screens/main/pages/campaign/campaign_detail_screen.dart';
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
      path: RoutePath.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/recruiting/:id',
      name: 'recruiting-detail',
      builder: (context, state) {
        final post = state.extra as RecruitingPost;
        final tabIndex = state.uri.queryParameters['tab'];
        return RecruitingDetailScreen(
          post: post,
          initialTabIndex: tabIndex == 'chat' ? 1 : 0,
        );
      },
    ),
    GoRoute(
      path: '/campaign/:id',
      name: 'campaign-detail',
      builder: (context, state) {
        final campaign = state.extra as CampaignData;
        return CampaignDetailScreen(campaign: campaign);
      },
    ),
  ],
  initialLocation: RoutePath.splash,
);
