import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/movies/presentation/movies_screen.dart';
import '../../features/movies/presentation/movie_detail_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/domain/auth_controller.dart';
import '../../features/main/presentation/main_layout_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'route_names.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'homeTab');
final shellNavigatorSearchKey = GlobalKey<NavigatorState>(debugLabel: 'searchTab');
final shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profileTab');

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<User?>>(
      authStateProvider,
      (_, _) => notifyListeners(),
    );
  }
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isAuth = authState.value != null;
      
      final isGoingToLogin = state.matchedLocation == RoutePaths.login;
      final isGoingToRegister = state.matchedLocation == RoutePaths.register;
      final isGoingToAuth = isGoingToLogin || isGoingToRegister;
      final isSplash = state.matchedLocation == RoutePaths.splash;

      if (!isAuth && !isGoingToAuth && !isSplash) {
        return RoutePaths.login;
      }
      
      if (isAuth && isGoingToAuth) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: RouteNames.splash,
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: RouteNames.login,
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: RouteNames.register,
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: RouteNames.movieDetail,
        path: RoutePaths.movieDetail,
        parentNavigatorKey: rootNavigatorKey, // Detay sayfası tüm tabların üzerine (fullscreen) açılır
        builder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '0';
          final movieId = int.tryParse(idStr) ?? 0;
          return MovieDetailScreen(movieId: movieId);
        },
      ),
      GoRoute(
        name: RouteNames.editProfile,
        path: '/profile/edit',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        name: RouteNames.userProfile,
        path: RoutePaths.userProfile,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final userId = state.pathParameters['id'];
          return ProfileScreen(userId: userId);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayoutScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorHomeKey,
            routes: [
              GoRoute(
                name: RouteNames.home,
                path: RoutePaths.home,
                builder: (context, state) => const MoviesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorSearchKey,
            routes: [
              GoRoute(
                name: RouteNames.search,
                path: RoutePaths.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorProfileKey,
            routes: [
              GoRoute(
                name: RouteNames.profile,
                path: RoutePaths.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
