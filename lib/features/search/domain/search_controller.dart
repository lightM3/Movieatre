import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../movies/data/sources/tmdb_api_client.dart';
import '../../movies/domain/models/movie.dart';

part 'search_controller.g.dart';

@riverpod
class SearchController extends _$SearchController {
  Timer? _debounceTimer;

  @override
  AsyncValue<List<Movie>> build() {
    return const AsyncValue.data([]);
  }

  void searchMovies(String query) {
    if (query.isEmpty) {
      _debounceTimer?.cancel();
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final movies = await ref.read(tmdbApiClientProvider).searchMovies(query);
        state = AsyncValue.data(movies);
      } catch (e, stack) {
        state = AsyncValue.error(e, stack);
      }
    });
  }
}
