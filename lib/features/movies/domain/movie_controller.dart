import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/movie.dart';
import '../data/repositories/movie_repository.dart';

part 'movie_controller.g.dart';

@riverpod
Future<List<Movie>> popularMovies(PopularMoviesRef ref) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getPopularMovies();
}
