import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/isar_provider.dart';
import 'core/network/supabase_client_provider.dart';
import 'core/routing/app_router.dart';

import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:movietre/firebase_options.dart';
import 'core/services/telemetry_service.dart';
import 'core/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Çevresel değişkenleri yükle
  await dotenv.load(fileName: ".env");

  // Firebase'i başlat
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Global Riverpod container'ını oluştur
  final container = ProviderContainer();
  final telemetry = container.read(telemetryServiceProvider);

  // Push Notification servisini başlat ve token al
  final pushService = container.read(pushNotificationServiceProvider);
  await pushService.initialize();
  await pushService.requestPermission();
  await pushService.getToken();

  // Flutter senkron hatalarını yakala
  FlutterError.onError = (errorDetails) {
    telemetry.recordError(
      errorDetails.exception,
      errorDetails.stack ?? StackTrace.empty,
      reason: errorDetails.context,
    );
  };

  // Asenkron hataları yakala
  PlatformDispatcher.instance.onError = (error, stack) {
    telemetry.recordError(error, stack, reason: 'Async Platform Error');
    return true;
  };

  // Supabase'i başlat
  await SupabaseInit.initialize();

  // Isar Veritabanını başlat
  await IsarInit.initialize();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
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
