import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/notification_service.dart';
import '../../auth/domain/auth_controller.dart';
import '../data/repositories/notification_repository.dart';

part 'notification_controller.g.dart';

@Riverpod(keepAlive: true)
class NotificationController extends _$NotificationController {
  @override
  void build() {
    // Controller oluşturulduğunda kullanıcı durumunu dinle
    ref.listen<AsyncValue<dynamic>>(
      authStateProvider,
      (previous, next) {
        final user = next.value;
        if (user != null) {
          _initializeNotifications(user.id);
        } else {
          _cleanupNotifications();
        }
      },
      fireImmediately: true,
    );
  }

  void _initializeNotifications(String userId) {
    final repo = ref.read(notificationRepositoryProvider);
    final notificationService = ref.read(notificationServiceProvider);

    repo.subscribeToNotifications(userId, (payload) {
      final title = payload['title'] as String? ?? 'Yeni Bildirim';
      final body = payload['body'] as String? ?? '';
      
      // Bildirim kimliği (ID) çakışmamalı, payload id'sini veya random kullanabiliriz.
      // Supabase'den gelen id genelde string UUID veya serial. Şimdilik DateTime milliseconds kullanıyoruz.
      final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

      notificationService.showNotification(
        id: id,
        title: title,
        body: body,
      );
    });
  }

  void _cleanupNotifications() {
    final repo = ref.read(notificationRepositoryProvider);
    repo.unsubscribe();
  }
}
