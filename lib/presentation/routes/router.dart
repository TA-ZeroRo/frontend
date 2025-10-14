import 'package:go_router/go_router.dart';

import '../../domain/model/post/post.dart';
import '../screens/campaign/campaign_recruiting_screen.dart';
import '../screens/entry/login_screen.dart';
import '../screens/entry/register_screen.dart';
import '../screens/entry/splash_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/post/edit_post_screen.dart';
import '../screens/verification/verify_image_screen.dart';
import '../screens/verification/verify_quiz_screen.dart';
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
      path: RoutePath.verifyImage,
      name: 'verifyImage',
      builder: (context, state) => const VerifyImageScreen(),
    ),
    GoRoute(
      path: RoutePath.verifyQuiz,
      name: 'verifyQuiz',
      builder: (context, state) => const VerifyQuizScreen(),
    ),
    GoRoute(
      path: RoutePath.newPost,
      name: 'newPost',
      builder: (context, state) => const EditPostScreen(),
    ),
    GoRoute(
      path: RoutePath.editPost,
      name: 'editPost',
      builder: (context, state) => EditPostScreen(
        post: state.extra as Post?,
      ),
    ),
    GoRoute(
      path: RoutePath.campaignRecruiting,
      name: 'campaignRecruiting',
      builder: (context, state) => const CampaignRecruitingScreen(),
    ),
  ],
  initialLocation: RoutePath.splash,
);
