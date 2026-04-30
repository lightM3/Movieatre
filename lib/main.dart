import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/env/env_config.dart';
import 'core/database/isar_provider.dart';
import 'core/network/supabase_client_provider.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Çevresel değişkenleri yükle
  await dotenv.load(fileName: ".env");
  
  // Supabase'i başlat
  await SupabaseInit.initialize();

  // Isar Veritabanını başlat
  await IsarInit.initialize();

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
