import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'notification_service.dart';

part 'push_notification_service.g.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // FCM Arka plan işlemleri burada yapılır. (Örn: Veritabanı güncelleme)
  try {
    debugPrint("Handling a background message: ${message.messageId}");
  } catch (e, stack) {
    debugPrint("Error handling background message: $e");
    // İzole bir alan olduğu için crashlytics kullanacaksak direkt instance üzerinden yazabiliriz
    FirebaseCrashlytics.instance.recordError(e, stack, reason: 'FCM Background Handler Error');
  }
}

abstract class IPushNotificationService {
  Future<void> initialize();
  Future<void> requestPermission();
  Future<String?> getToken();
}

class PushNotificationService implements IPushNotificationService {
  final NotificationService _notificationService;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  PushNotificationService(this._notificationService);

  @override
  Future<void> initialize() async {
    try {
      // Arka plan mesaj dinleyicisini kaydet
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Ön plan (Foreground) mesaj dinleyicisi
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint('Message also contained a notification: ${message.notification}');
          // Yerel bildirim servisi ile ekranda göster
          _notificationService.showNotification(
            id: message.messageId.hashCode,
            title: message.notification?.title ?? 'Yeni Bildirim',
            body: message.notification?.body ?? '',
            payload: message.data.toString(),
          );
        }
      });

      // Uygulama kapalıyken (Terminated) bildirime tıklanıp açıldığında
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpen(initialMessage);
      }

      // Uygulama arka plandayken (Background) bildirime tıklandığında
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpen);
    } catch (e, stack) {
      debugPrint('PushNotificationService initialize error: $e');
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'PushNotificationService initialization failed');
    }
  }

  @override
  Future<void> requestPermission() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('User granted permission: ${settings.authorizationStatus}');
    } catch (e, stack) {
      debugPrint('PushNotificationService permission error: $e');
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'PushNotificationService requestPermission failed');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('FCM Token: $token');
      return token;
    } catch (e, stack) {
      debugPrint('PushNotificationService getToken error: $e');
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'PushNotificationService getToken failed');
      return null;
    }
  }

  void _handleMessageOpen(RemoteMessage message) {
    // Burada yönlendirme (routing) işlemleri yapılabilir.
    // İleride app_router ile entegre edilerek spesifik ekranlara geçiş sağlanabilir.
    debugPrint('Message clicked! Payload: ${message.data}');
  }
}

@riverpod
IPushNotificationService pushNotificationService(PushNotificationServiceRef ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return PushNotificationService(notificationService);
}
