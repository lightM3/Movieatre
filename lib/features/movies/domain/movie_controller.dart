import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/movie.dart';
import '../data/repositories/movie_repository.dart';

part 'movie_controller.g.dart';

class MoviesState {
  final List<Movie> movies;
  final int currentPage;
  final bool isLoadingMore;
  final bool hasReachedMax;

  MoviesState({
    this.movies = const [],
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  MoviesState copyWith({
    List<Movie>? movies,
    int? currentPage,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

@riverpod
class PopularMovies extends _$PopularMovies {
  @override
  FutureOr<MoviesState> build() async {
    final movies = await ref.read(movieRepositoryProvider).getPopularMovies(page: 1);
    return MoviesState(
      movies: movies,
      currentPage: 1,
      hasReachedMax: movies.isEmpty,
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    // Eğer mevcut state yoksa, daha fazla yükleniyorsa veya maksimuma ulaşıldıysa çık.
    if (currentState == null || currentState.isLoadingMore || currentState.hasReachedMax) {
      return;
    }

    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final newMovies = await ref.read(movieRepositoryProvider).getPopularMovies(page: nextPage);
      
      state = AsyncData(currentState.copyWith(
        movies: [...currentState.movies, ...newMovies],
        currentPage: nextPage,
        isLoadingMore: false,
        hasReachedMax: newMovies.isEmpty,
      ));
    } catch (e) {
      // Hata durumunda yüklemeyi durdur.
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> shuffleAndReload() async {
    // Tüm state'i sıfırlayıp Loading moduna al.
    state = const AsyncLoading();
    
    try {
      // 1 ile 50 arasında rastgele bir sayfa üret
      final randomPage = Random().nextInt(50) + 1;
      
      // Rastgele sayfayı çek
      final movies = await ref.read(movieRepositoryProvider).getPopularMovies(page: randomPage);
      
      // Çekilen filmleri kendi içinde de rastgele karıştır
      final shuffledMovies = List<Movie>.from(movies)..shuffle();
      
      state = AsyncData(MoviesState(
        movies: shuffledMovies,
        currentPage: randomPage, // randomPage'den devam edebilmek için atıyoruz
        hasReachedMax: movies.isEmpty,
      ));
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
