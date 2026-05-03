import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../movies/domain/models/movie.dart';
import '../../movies/data/sources/tmdb_api_client.dart';
import '../../movies/data/sources/movie_local_data_source.dart';
import '../../reviews/domain/models/profile.dart';
import '../../reviews/domain/models/review.dart';
import '../../reviews/data/repositories/review_repository.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../data/repositories/follow_repository.dart';

part 'profile_controller.g.dart';

class ProfileState {
  final Profile profile;
  final List<Movie> topFourMovies;
  final List<ReviewWithMovie> recentReviews;
  final int followersCount;
  final int followingCount;

  ProfileState({
    required this.profile,
    required this.topFourMovies,
    required this.recentReviews,
    required this.followersCount,
    required this.followingCount,
  });
}

class ReviewWithMovie {
  final Review review;
  final Movie? movie;

  ReviewWithMovie({required this.review, this.movie});
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<ProfileState> build([String? userId]) async {
    return _fetchProfileData(userId);
  }

  Future<ProfileState> _fetchProfileData(String? userId) async {
    final supabase = ref.read(supabaseClientProvider);
    final currentUserId = supabase.auth.currentUser?.id;
    final targetUserId = userId ?? currentUserId;
    
    if (targetUserId == null) {
      throw Exception('Kullanıcı bulunamadı.');
    }

    // 1. Fetch Profile
    final profileResponse = await supabase
        .from('profiles')
        .select()
        .eq('id', targetUserId)
        .single();
    
    final profile = Profile.fromJson(profileResponse);

    // 2. Fetch Top 4 Movies
    final List<Movie> topFourMovies = [];
    if (profile.topFourMovies != null && profile.topFourMovies!.isNotEmpty) {
      final futures = profile.topFourMovies!.take(4).map((movieId) => _getMovie(movieId));
      final movies = await Future.wait(futures);
      topFourMovies.addAll(movies.whereType<Movie>()); // null olmayanları ekle
    }

    // 3. Fetch Recent Reviews
    final reviewRepo = ref.read(reviewRepositoryProvider);
    final recentReviews = await reviewRepo.getUserReviews(targetUserId);
    
    // N+1 Query çözüm: Future.wait ile Isar & TMDB fallback
    final reviewFutures = recentReviews.map((review) async {
      final movie = await _getMovie(review.tmdbMovieId);
      return ReviewWithMovie(review: review, movie: movie);
    });
    
    final recentReviewsWithMovies = await Future.wait(reviewFutures);

    // 4. Fetch Follows Count
    final followRepo = ref.read(followRepositoryProvider);
    final followersCount = await followRepo.getFollowersCount(targetUserId);
    final followingCount = await followRepo.getFollowingCount(targetUserId);

    return ProfileState(
      profile: profile,
      topFourMovies: topFourMovies,
      recentReviews: recentReviewsWithMovies,
      followersCount: followersCount,
      followingCount: followingCount,
    );
  }

  Future<Movie?> _getMovie(int movieId) async {
    try {
      // Önce Isar cache kontrolü
      final localSource = ref.read(movieLocalDataSourceProvider);
      final cachedMovie = await localSource.getMovieById(movieId);
      if (cachedMovie != null) {
        return cachedMovie.toDomain();
      }

      // Isar'da yoksa API'den detay çek, DTO'ya dönüştür
      final apiSource = ref.read(tmdbApiClientProvider);
      final movieDetail = await apiSource.getMovieDetails(movieId);
      
      return Movie(
        id: movieDetail.id,
        title: movieDetail.title,
        posterPath: movieDetail.posterPath,
        backdropPath: movieDetail.backdropPath,
        overview: movieDetail.overview,
        voteAverage: movieDetail.voteAverage,
        releaseDate: movieDetail.releaseDate,
        genreIds: [],
      );
    } catch (e) {
      // Hata olursa (örn API rate limit) null dön, uygulama çökmesin
      return null;
    }
  }
}
