import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injector.dart';
import '../core/theme/app_spacing.dart';
import '../features/auth/domain/entities/auth_session.dart';
import '../features/auth/presentation/bloc/login/login_bloc.dart';
import '../features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../features/chat/presentation/bloc/chat_bloc.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/daily_law/presentation/bloc/collection_bloc.dart';
import '../features/daily_law/presentation/bloc/daily_law_bloc.dart';
import '../features/daily_law/presentation/pages/collection_page.dart';
import '../features/daily_law/presentation/pages/daily_law_page.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/intro/presentation/bloc/intro_bloc.dart';
import '../features/intro/presentation/pages/intro_page.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/splash/presentation/bloc/splash_bloc.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';
import 'app_shell.dart';

abstract final class AppRouter {
  static GoRouter create() {
    final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();

    return GoRouter(
      navigatorKey: rootKey,
      initialLocation: AppRoutes.splash,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.splash,
          pageBuilder: (BuildContext context, GoRouterState state) => _fade(
            state,
            BlocProvider<SplashBloc>(
              create: (_) => injector<SplashBloc>()..add(const SplashStarted()),
              child: SplashPage(
                onAuthenticated: () => context.go(AppRoutes.home),
                onIntroNeeded: () => context.go(AppRoutes.intro),
                onUnauthenticated: () => context.go(AppRoutes.login),
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.intro,
          pageBuilder: (BuildContext context, GoRouterState state) => _fade(
            state,
            BlocProvider<IntroBloc>(
              create: (_) => injector<IntroBloc>(),
              child: IntroPage(onFinished: () => context.go(AppRoutes.login)),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          pageBuilder: (BuildContext context, GoRouterState state) => _fade(
            state,
            BlocProvider<LoginBloc>(
              create: (_) => injector<LoginBloc>(),
              child: LoginPage(
                onSignedIn: (AuthSession session) => context.go(AppRoutes.home),
                onSignUpRequested: () => context.push(AppRoutes.signUp),
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.signUp,
          pageBuilder: (BuildContext context, GoRouterState state) => _fade(
            state,
            BlocProvider<SignUpBloc>(
              create: (_) => injector<SignUpBloc>(),
              child: SignUpPage(
                onSignedUp: (AuthSession session) =>
                    context.go(AppRoutes.welcome, extra: session),
                onLoginRequested: () => context.pop(),
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.welcome,
          redirect: (BuildContext context, GoRouterState state) =>
              state.extra is AuthSession ? null : AppRoutes.home,
          pageBuilder: (BuildContext context, GoRouterState state) {
            final AuthSession session = state.extra! as AuthSession;
            return _fade(
              state,
              WelcomePage(
                user: session.user,
                onContinue: () => context.go(AppRoutes.home),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.dailyLaw,
          parentNavigatorKey: rootKey,
          pageBuilder: (BuildContext context, GoRouterState state) => _fade(
            state,
            BlocProvider<DailyLawBloc>(
              create: (_) => injector<DailyLawBloc>(),
              child: DailyLawPage(onClose: () => context.go(AppRoutes.home)),
            ),
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell shell,
          ) =>
              AppShell(navigationShell: shell),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.home,
                  builder: (BuildContext context, GoRouterState state) =>
                      MultiBlocProvider(
                    providers: <BlocProvider<dynamic>>[
                      BlocProvider<DailyLawBloc>(
                        create: (_) => injector<DailyLawBloc>(),
                      ),
                      BlocProvider<HomeBloc>(
                        create: (_) => injector<HomeBloc>(),
                      ),
                    ],
                    child: HomePage(
                      onAsk: (String? question) => context.go(
                        AppRoutes.chat,
                        extra: question,
                      ),
                      onOpenBox: () => context.push(AppRoutes.dailyLaw),
                      onOpenCollection: () => context.go(AppRoutes.collection),
                      onOpenProfile: () => context.go(AppRoutes.profile),
                    ),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.chat,
                  builder: (BuildContext context, GoRouterState state) =>
                      BlocProvider<ChatBloc>(
                    create: (_) => injector<ChatBloc>(),
                    child: ChatPage(initialQuestion: state.extra as String?),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.collection,
                  builder: (BuildContext context, GoRouterState state) =>
                      BlocProvider<CollectionBloc>(
                    create: (_) => injector<CollectionBloc>(),
                    child: CollectionPage(onOpenLaw: (_) {}),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.profile,
                  builder: (BuildContext context, GoRouterState state) =>
                      BlocProvider<ProfileBloc>(
                    create: (_) => injector<ProfileBloc>(),
                    child: ProfilePage(
                      onSignedOut: () => context.go(AppRoutes.login),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: AppDuration.base,
      reverseTransitionDuration: AppDuration.fast,
      child: child,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        final CurvedAnimation curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.02),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
