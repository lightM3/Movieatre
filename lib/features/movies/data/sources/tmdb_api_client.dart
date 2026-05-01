import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../domain/models/movie.dart';
import '../../domain/models/movie_detail.dart';
import '../../../../core/error/custom_exceptions.dart';

part 'tmdb_api_client.g.dart';

class TmdbApiClient {
  final Dio _dio;

  TmdbApiClient(this._dio);

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw NetworkException('TMDB API Hatası: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkException('Bağlantı hatası: ${e.message}');
    } catch (e) {
      throw NetworkException('Beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<MovieDetail> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId',
        queryParameters: {
          'append_to_response': 'credits,videos',
        },
      );

      if (response.statusCode == 200) {
        return MovieDetail.fromJson(response.data);
      } else {
        throw NetworkException('TMDB API Hatası: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkException('Bağlantı hatası: ${e.message}');
    } catch (e) {
      throw NetworkException('Beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'query': query,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw NetworkException('TMDB API Hatası: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkException('Bağlantı hatası: ${e.message}');
    } catch (e) {
      throw NetworkException('Beklenmeyen bir hata oluştu: $e');
    }
  }
}

@riverpod
TmdbApiClient tmdbApiClient(TmdbApiClientRef ref) {
  return TmdbApiClient(ref.watch(dioClientProvider));
}
