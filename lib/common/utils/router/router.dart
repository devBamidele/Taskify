import 'package:go_router/go_router.dart';
import 'package:task_app/feature/auth/view/login/login_screen.dart';
import 'package:task_app/feature/auth/view/signup/signup_screen.dart';
import 'package:task_app/feature/splash.dart';
import 'package:task_app/feature/tasks/view/home/home_screen.dart';
import 'package:task_app/feature/tasks/view/home/task_screen.dart';

import '../../../feature/tasks/model/task.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.task,
      builder: (context, state) => TaskScreen(task: (state.extra as Task?)),
    ),
  ],
);
