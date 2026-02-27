import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/forgot_password_success_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/welcome_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/main_navigation.dart';
import '../../features/plan/plan_screen.dart';
import '../../features/profile/help_center_screen.dart';
import '../../features/profile/privacy_policy_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/security_settings_screen.dart';
import '../../features/tasks/add_task_screen.dart';
import '../../features/tasks/list_screen.dart';
import '../../features/tasks/task_detail_screen.dart';
import '../../models/task_model.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static const String home = '/';
  static const String list = '/list';
  static const String plan = '/plan';
  static const String profile = '/profile';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
  static const String taskDetail = '/task-detail';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordSuccess = '/forgot-password-success';
  static const String welcome = '/welcome';
  static const String security = '/security';
  static const String help = '/help';
  static const String privacy = '/privacy';

  static GoRouter getRouter(bool isLoggedIn) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: isLoggedIn ? home : login,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: welcome,
          name: 'welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: signup,
          name: 'signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: forgotPassword,
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: forgotPasswordSuccess,
          name: 'forgot-password-success',
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return ForgotPasswordSuccessScreen(email: email);
          },
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainNavigation(child: child);
          },
          routes: [
            GoRoute(
              path: home,
              name: 'home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
            GoRoute(
              path: list,
              name: 'list',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ListScreen(),
              ),
            ),
            GoRoute(
              path: plan,
              name: 'plan',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PlanScreen(),
              ),
            ),
            GoRoute(
              path: profile,
              name: 'profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfileScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: addTask,
          name: 'add-task',
          builder: (context, state) {
            final dateStr = state.uri.queryParameters['date'];
            final preselectedDate =
                dateStr != null ? DateTime.tryParse(dateStr) : null;
            return AddTaskScreen(preselectedDate: preselectedDate);
          },
        ),
        GoRoute(
          path: '$editTask/:id',
          name: 'edit-task',
          builder: (context, state) {
            final task = state.extra as TaskModel?;
            return AddTaskScreen(taskToEdit: task);
          },
        ),
        GoRoute(
          path: '$taskDetail/:id',
          name: 'task-detail',
          builder: (context, state) {
            final task = state.extra as TaskModel?;
            if (task == null) {
              return const Scaffold(
                body: Center(child: Text('Task not found')),
              );
            }
            return TaskDetailScreen(task: task);
          },
        ),
        GoRoute(
          path: security,
          name: 'security',
          builder: (context, state) => const SecuritySettingsScreen(),
        ),
        GoRoute(
          path: help,
          name: 'help',
          builder: (context, state) => const HelpCenterScreen(),
        ),
        GoRoute(
          path: privacy,
          name: 'privacy',
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
      ],
      errorBuilder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Page not found: ${state.uri.path}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(home),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static GoRouter get router => getRouter(true);

  static bool isAuthRoute(String location) {
    return location == login ||
        location == signup ||
        location == forgotPassword;
  }
}

extension AppRouterExtension on BuildContext {
  void pushNamedRoute(String name, {Object? extra}) {
    GoRouter.of(this).pushNamed(name, extra: extra);
  }

  void pushRoute(String path, {Object? extra}) {
    GoRouter.of(this).push(path, extra: extra);
  }

  void goRoute(String path, {Object? extra}) {
    GoRouter.of(this).go(path, extra: extra);
  }

  void popRoute() {
    GoRouter.of(this).pop();
  }
}
