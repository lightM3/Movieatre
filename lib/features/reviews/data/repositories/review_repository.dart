import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/error/custom_exceptions.dart';
import '../../domain/models/review.dart';

part 'review_repository.g.dart';

class ReviewRepository {
  final SupabaseClient _supabase;

  ReviewRepository(this._supabase);

  Future<List<Review>> getMovieReviews(int movieId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('*, profiles(*)')
          .eq('tmdb_movie_id', movieId)
          .order('created_at', ascending: false);

      return (response as List).map((e) => Review.fromJson(e)).toList();
    } catch (e) {
      throw DatabaseException('Yorumlar yüklenemedi: $e');
    }
  }

  Future<Review> addOrUpdateReview(int movieId, double rating, String? content) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw AuthException('Yorum yapmak için giriş yapmalısınız.');

      final response = await _supabase
          .from('reviews')
          .upsert(
            {
              'user_id': userId,
              'tmdb_movie_id': movieId,
              'rating': rating,
              if (content != null && content.isNotEmpty) 'content': content,
            },
            onConflict: 'user_id, tmdb_movie_id',
          )
          .select('*, profiles(*)')
          .single();

      return Review.fromJson(response);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw DatabaseException('Yorum eklenirken hata oluştu: $e');
    }
  }
}

@riverpod
ReviewRepository reviewRepository(ReviewRepositoryRef ref) {
  return ReviewRepository(ref.watch(supabaseClientProvider));
}
