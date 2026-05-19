import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../movies/domain/models/movie.dart';
import '../../movies/data/sources/tmdb_api_client.dart';
import '../../movies/data/sources/movie_local_data_source.dart';
import '../data/repositories/list_repository.dart';
import '../../../core/error/custom_exceptions.dart';
import 'list_controller.dart';

part 'list_detail_controller.g.dart';

@riverpod
class ListDetailController extends _$ListDetailController {
  @override
  FutureOr<List<Movie>> build(String listId) async {
    // Reaktif Senkronizasyon: listControllerProvider değiştiğinde
    // bu sayfadaki film listesini anında filtrele (API çağrısı yok).
    ref.listen(listControllerProvider(null), (previous, next) {
      if (!next.hasValue || !state.hasValue) return;

      final lists = next.value!;
      // Bu listId'ye ait güncel movieIds'i bul
      final currentList = lists.where((l) => l.id == listId);
      if (currentList.isEmpty) return;

      final validMovieIds = currentList.first.movieIds.toSet();
      final currentMovies = state.value!;

      // Eğer film sayısında değişim varsa, anında filtrele
      final filtered = currentMovies
          .where((movie) => validMovieIds.contains(movie.id))
          .toList();

      if (filtered.length != currentMovies.length) {
        state = AsyncValue.data(filtered);
      }
    });

    return _fetchListMovies(listId);
  }

  Future<List<Movie>> _fetchListMovies(String listId) async {
    try {
      final repository = ref.read(listRepositoryProvider);
      final listDetail = await repository.getListDetails(listId);

      if (listDetail.movieIds.isEmpty) {
        return [];
      }

      final apiClient = ref.read(tmdbApiClientProvider);
      final localSource = ref.read(movieLocalDataSourceProvider);

      // Paralel isteklerle film detaylarını çek (cache-first)
      final movieFutures = listDetail.movieIds.map((movieId) async {
        try {
          // Önce Isar cache kontrolü
          final cached = await localSource.getMovieById(movieId);
          if (cached != null) {
            return cached.toDomain();
          }

          // Cache'de yoksa API'den çek
          final detail = await apiClient.getMovieDetails(movieId);
          return Movie(
            id: detail.id,
            title: detail.title,
            posterPath: detail.posterPath,
            backdropPath: detail.backdropPath,
            overview: detail.overview,
            voteAverage: detail.voteAverage,
            releaseDate: detail.releaseDate,
            genreIds: [],
          );
        } catch (_) {
          // Graceful degradation: hata alan filmleri atla
          return null;
        }
      });

      final results = await Future.wait(movieFutures);
      return results.whereType<Movie>().toList();
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw NetworkException('Liste filmleri yüklenemedi: $e');
    }
  }

  /// Listeyi yeniden yükler (Pull-to-refresh veya liste değişikliği sonrası)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchListMovies(listId));
  }
}
