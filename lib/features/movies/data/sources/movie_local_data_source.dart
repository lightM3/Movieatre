import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/isar_provider.dart';
import '../models/movie_entity.dart';
import '../../../../core/error/custom_exceptions.dart';

part 'movie_local_data_source.g.dart';

class MovieLocalDataSource {
  final Isar _isar;

  MovieLocalDataSource(this._isar);

  Future<void> cacheMovies(List<MovieEntity> movies) async {
    try {
      await _isar.writeTxn(() async {
        // Popüler filmleri temizleyip yenilerini ekleyebiliriz 
        // veya sadece ID'ye göre replace yapabiliriz. (replace: true kullanmıştık)
        await _isar.movieEntitys.putAll(movies);
      });
    } catch (e) {
      throw DatabaseException('Filmler önbelleğe kaydedilemedi: $e');
    }
  }

  Future<List<MovieEntity>> getCachedMovies() async {
    try {
      return await _isar.movieEntitys.where().findAll();
    } catch (e) {
      throw DatabaseException('Filmler önbellekten okunamadı: $e');
    }
  }
}

@riverpod
MovieLocalDataSource movieLocalDataSource(MovieLocalDataSourceRef ref) {
  return MovieLocalDataSource(ref.watch(isarProvider));
}
