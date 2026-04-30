import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/domain/auth_controller.dart';
import 'route_names.dart';

part 'app_router.g.dart';

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
    initialLocation: RoutePaths.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isAuth = authState.value != null;
      
      final isGoingToLogin = state.matchedLocation == RoutePaths.login;
      final isGoingToRegister = state.matchedLocation == RoutePaths.register;
      final isGoingToAuth = isGoingToLogin || isGoingToRegister;
      final isSplash = state.matchedLocation == RoutePaths.splash;

      // Splash ekranındayken yönlendirme (splash ekranında 2 saniye bekliyoruz gerçi ama guard devrede olacak)
      // Ancak Splash ekranındaki Future.delayed logic'ine dokunmuyoruz ki animasyon görünsün.
      // Bu guard o geçişi kontrol altında tutacak.
      
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
        name: RouteNames.home,
        path: RoutePaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
