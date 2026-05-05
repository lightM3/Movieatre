import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/error/custom_exceptions.dart';
import '../../../reviews/domain/models/review.dart';

part 'feed_repository.g.dart';

class FeedRepository {
  final SupabaseClient _supabase;

  FeedRepository(this._supabase);

  Future<List<Review>> getFollowingReviews(String currentUserId) async {
    try {
      // 1. Get following IDs
      final followersResponse = await _supabase
          .from('followers')
          .select('following_id')
          .eq('follower_id', currentUserId);

      if (followersResponse.isEmpty) {
        return [];
      }

      final followingIds = followersResponse.map((e) => e['following_id'] as String).toList();

      if (followingIds.isEmpty) {
        return [];
      }

      // 2. Get reviews for these IDs
      final reviewsResponse = await _supabase
          .from('reviews')
          .select('*, profiles(*)')
          .inFilter('user_id', followingIds)
          .order('created_at', ascending: false)
          .limit(20);

      return (reviewsResponse as List).map((json) => Review.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw DatabaseException('Aktivite akışı getirilirken veritabanı hatası oluştu', code: e.message);
    } catch (e) {
      throw UnknownException('Beklenmeyen bir hata oluştu: $e');
    }
  }
}

@riverpod
FeedRepository feedRepository(FeedRepositoryRef ref) {
  return FeedRepository(ref.watch(supabaseClientProvider));
}
