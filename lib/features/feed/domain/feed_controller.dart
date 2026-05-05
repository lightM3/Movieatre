import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/custom_exceptions.dart';
import '../../auth/domain/auth_controller.dart';
import '../../movies/domain/models/movie.dart';
import '../../movies/data/models/movie_entity.dart';
import '../../movies/data/sources/movie_local_data_source.dart';
import '../../movies/data/sources/tmdb_api_client.dart';
import '../../reviews/domain/models/review.dart';
import '../data/repositories/feed_repository.dart';

part 'feed_controller.g.dart';

class FeedState {
  final List<Review> reviews;
  final Map<int, Movie> movies;

  FeedState({
    required this.reviews,
    required this.movies,
  });

  FeedState copyWith({
    List<Review>? reviews,
    Map<int, Movie>? movies,
  }) {
    return FeedState(
      reviews: reviews ?? this.reviews,
      movies: movies ?? this.movies,
    );
  }
}

@riverpod
class FeedController extends _$FeedController {
  @override
  FutureOr<FeedState> build() async {
    return _fetchFeed();
  }

  Future<FeedState> _fetchFeed() async {
    final authState = ref.read(authStateProvider);
    final user = authState.value;

    if (user == null) {
      throw AuthException('Kullanıcı oturumu bulunamadı.');
    }

    // 1. Fetch following reviews
    final repository = ref.read(feedRepositoryProvider);
    final reviews = await repository.getFollowingReviews(user.id);

    if (reviews.isEmpty) {
      return FeedState(reviews: [], movies: {});
    }

    // 2. Resolve Movies (N+1 Optimization)
    final Map<int, Movie> resolvedMovies = {};
    final localDataSource = ref.read(movieLocalDataSourceProvider);
    final tmdbClient = ref.read(tmdbApiClientProvider);

    // Get unique movie IDs
    final movieIdsToFetch = reviews.map((r) => r.tmdbMovieId).toSet().toList();

    await Future.wait(
      movieIdsToFetch.map((id) async {
        try {
          // Önce Isar Cache'e bak
          final entity = await localDataSource.getMovieById(id);
          Movie? movie = entity?.toDomain();

          // Cache'te yoksa TMDB API'den çek ve kaydet
          if (movie == null) {
            final detail = await tmdbClient.getMovieDetails(id);
            movie = Movie(
              id: detail.id,
              title: detail.title,
              posterPath: detail.posterPath,
              backdropPath: detail.backdropPath,
              overview: detail.overview,
              voteAverage: detail.voteAverage,
              releaseDate: detail.releaseDate,
            );
            await localDataSource.cacheMovies([MovieEntity.fromDomain(movie)]);
          }

          resolvedMovies[id] = movie;
        } catch (e) {
          // Bir filmin yüklenememesi tüm akışı bozmasın
        }
      }),
    );

    return FeedState(
      reviews: reviews,
      movies: resolvedMovies,
    );
  }
}
