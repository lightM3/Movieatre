import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/movie.dart';
import '../models/movie_entity.dart';
import '../sources/tmdb_api_client.dart';
import '../sources/movie_local_data_source.dart';
import '../../../../core/error/custom_exceptions.dart';

part 'movie_repository.g.dart';

class MovieRepository {
  final TmdbApiClient _apiClient;
  final MovieLocalDataSource _localDataSource;

  MovieRepository(this._apiClient, this._localDataSource);

  Future<List<Movie>> getPopularMovies() async {
    try {
      // 1. Önce API'den güncel veriyi çekmeyi dene
      final moviesFromApi = await _apiClient.getPopularMovies();
      
      // 2. Başarılı olursa Isar'a kaydet (Mapper kullanarak)
      final entities = moviesFromApi.map((m) => MovieEntity.fromDomain(m)).toList();
      await _localDataSource.cacheMovies(entities);
      
      return moviesFromApi;
    } on NetworkException catch (_) {
      // 3. İnternet yoksa veya API hatası varsa önbellekten getir
      try {
        final cachedEntities = await _localDataSource.getCachedMovies();
        if (cachedEntities.isNotEmpty) {
          return cachedEntities.map((e) => e.toDomain()).toList();
        } else {
          // Önbellek de boşsa hatayı fırlat
          throw NetworkException('İnternet bağlantısı yok ve önbellekte veri bulunamadı.');
        }
      } catch (e) {
        throw NetworkException('Veri getirilirken hata oluştu: $e');
      }
    }
  }
}

@riverpod
MovieRepository movieRepository(MovieRepositoryRef ref) {
  return MovieRepository(
    ref.watch(tmdbApiClientProvider),
    ref.watch(movieLocalDataSourceProvider),
  );
}
