import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/movie_list.dart';
import '../data/repositories/list_repository.dart';

part 'list_controller.g.dart';

@riverpod
class ListController extends _$ListController {
  @override
  FutureOr<List<MovieList>> build() async {
    return _fetchLists();
  }

  Future<List<MovieList>> _fetchLists() async {
    return ref.read(listRepositoryProvider).getUserLists();
  }

  Future<void> createList(String title, {String? description}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(listRepositoryProvider);
      await repository.createList(title, description: description);
      // Yeni liste eklendikten sonra listeleri tekrar çek
      return _fetchLists();
    });
  }

  Future<void> toggleMovieInList(String listId, int tmdbMovieId) async {
    // Sadece mevcut listeyi anında UI'da değiştirmek için state kopyalanabilir 
    // ama en güvenlisi veritabanı isteği sonrası veriyi güncellemektir.
    final previousState = state;
    
    // Optimistic Update yapılabilir:
    if (state.hasValue) {
      final lists = state.value!;
      final updatedLists = lists.map((list) {
        if (list.id == listId) {
          final newMovieIds = List<int>.from(list.movieIds);
          if (newMovieIds.contains(tmdbMovieId)) {
            newMovieIds.remove(tmdbMovieId);
          } else {
            newMovieIds.add(tmdbMovieId);
          }
          return list.copyWith(movieIds: newMovieIds);
        }
        return list;
      }).toList();
      state = AsyncValue.data(updatedLists);
    }

    try {
      final repository = ref.read(listRepositoryProvider);
      await repository.toggleMovieInList(listId, tmdbMovieId);
      // Gerçek durumu garantilemek için tekrar fetch edilebilir, ancak optimistic update çoğu zaman yeterlidir.
    } catch (e) {
      // Hata olursa geri al
      state = previousState;
      // İsterseniz burada UI'a hata göstermek için bir mekanizma eklenebilir
    }
  }
}
