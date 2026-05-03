import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/error/custom_exceptions.dart';

part 'follow_repository.g.dart';

class FollowRepository {
  final SupabaseClient _supabase;

  FollowRepository(this._supabase);

  Future<void> followUser(String targetUserId) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) throw AuthException('Oturum bulunamadı');
      
      if (currentUserId == targetUserId) {
        throw DatabaseException('Kendinizi takip edemezsiniz');
      }

      await _supabase.from('followers').insert({
        'follower_id': currentUserId,
        'following_id': targetUserId,
      });
    } catch (e) {
      if (e is AppException) rethrow;
      throw DatabaseException('Takip işlemi başarısız: $e');
    }
  }

  Future<void> unfollowUser(String targetUserId) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) throw AuthException('Oturum bulunamadı');

      await _supabase
          .from('followers')
          .delete()
          .match({
        'follower_id': currentUserId,
        'following_id': targetUserId,
      });
    } catch (e) {
      if (e is AppException) rethrow;
      throw DatabaseException('Takipten çıkma işlemi başarısız: $e');
    }
  }

  Future<bool> checkIsFollowing(String targetUserId) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) return false;

      final result = await _supabase
          .from('followers')
          .select('id')
          .match({
        'follower_id': currentUserId,
        'following_id': targetUserId,
      }).maybeSingle();

      return result != null;
    } catch (e) {
      return false; // Hata durumunda varsayılan olarak takip etmiyor diyelim
    }
  }

  Future<int> getFollowersCount(String userId) async {
    try {
      final result = await _supabase
          .from('followers')
          .select('id')
          .eq('following_id', userId)
          .count(CountOption.exact);

      return result.count;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getFollowingCount(String userId) async {
    try {
      final result = await _supabase
          .from('followers')
          .select('id')
          .eq('follower_id', userId)
          .count(CountOption.exact);

      return result.count;
    } catch (e) {
      return 0;
    }
  }
}

@riverpod
FollowRepository followRepository(FollowRepositoryRef ref) {
  return FollowRepository(ref.watch(supabaseClientProvider));
}
