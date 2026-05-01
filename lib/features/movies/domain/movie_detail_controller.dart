import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/movie_detail.dart';
import '../data/sources/tmdb_api_client.dart';

part 'movie_detail_controller.g.dart';

@riverpod
Future<MovieDetail> movieDetail(MovieDetailRef ref, int movieId) async {
  final apiClient = ref.watch(tmdbApiClientProvider);
  return apiClient.getMovieDetails(movieId);
}
