import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/supabase_client_provider.dart';

part 'notification_repository.g.dart';

class NotificationRepository {
  final SupabaseClient _supabase;
  RealtimeChannel? _channel;

  NotificationRepository(this._supabase);

  Stream<List<Map<String, dynamic>>> listenToNotifications(String userId) {
    // Return a stream using stream() method of Supabase, 
    // or manually manage a StreamController and listen to Realtime.
    // For simplicity and reactivity, Supabase's stream is best:
    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  void subscribeToNotifications(
    String userId,
    void Function(Map<String, dynamic> payload) onNotificationReceived,
  ) {
    // Önceki kanal açıksa kapat
    unsubscribe();

    _channel = _supabase.channel('public:notifications:user_$userId');

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onNotificationReceived(payload.newRecord);
          },
        )
        .subscribe();
  }

  void unsubscribe() {
    if (_channel != null) {
      _supabase.removeChannel(_channel!);
      _channel = null;
    }
  }
}

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return NotificationRepository(ref.watch(supabaseClientProvider));
}
