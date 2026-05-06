import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/error/custom_exceptions.dart';
import '../../../../core/network/supabase_client_provider.dart';

part 'like_repository.g.dart';

class LikeRepository {
  final SupabaseClient _supabase;

  LikeRepository(this._supabase);

  Future<void> toggleLike(String reviewId, String userId, bool isLiked) async {
    try {
      if (isLiked) {
        // Zaten beğenilmişse, beğeniyi kaldır (Delete)
        await _supabase
            .from('review_likes')
            .delete()
            .match({'review_id': reviewId, 'user_id': userId});
      } else {
        // Beğenilmemişse, ekle (Insert)
        await _supabase.from('review_likes').insert({
          'review_id': reviewId,
          'user_id': userId,
        });
      }
    } on PostgrestException catch (e) {
      throw DatabaseException('Beğeni işlemi başarısız', code: e.message);
    } catch (e) {
      throw UnknownException('Beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<({int likeCount, bool isLiked})> getLikeState(
      String reviewId, String currentUserId) async {
    try {
      // 1. Toplam beğeni sayısını al
      final countResponse = await _supabase
          .from('review_likes')
          .select('id')
          .eq('review_id', reviewId)
          .count(CountOption.exact);

      // 2. Mevcut kullanıcının beğenip beğenmediğini kontrol et
      final likedResponse = await _supabase
          .from('review_likes')
          .select('id')
          .match({'review_id': reviewId, 'user_id': currentUserId})
          .limit(1);

      return (
        likeCount: countResponse.count,
        isLiked: likedResponse.isNotEmpty,
      );
    } on PostgrestException catch (e) {
      throw DatabaseException('Beğeni durumu alınamadı', code: e.message);
    } catch (e) {
      throw UnknownException('Beklenmeyen bir hata oluştu: $e');
    }
  }
}

@riverpod
LikeRepository likeRepository(LikeRepositoryRef ref) {
  return LikeRepository(ref.watch(supabaseClientProvider));
}
