import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/env/env_config.dart';
import 'core/network/supabase_client_provider.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Çevresel değişkenleri yükle
  await EnvConfig.init();
  
  // Supabase'i başlat
  await SupabaseInit.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Movietre',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
