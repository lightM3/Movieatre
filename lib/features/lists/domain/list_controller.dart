import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/movie_list.dart';
import '../data/repositories/list_repository.dart';

part 'list_controller.g.dart';

@riverpod
class ListController extends _$ListController {
  @override
  FutureOr<List<MovieList>> build([String? userId]) async {
    return _fetchLists(userId);
  }

  Future<List<MovieList>> _fetchLists(String? userId) async {
    return ref.read(listRepositoryProvider).getUserLists(userId);
  }

  Future<void> createList(String title, {String? description}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(listRepositoryProvider);
      await repository.createList(title, description: description);
      // Yeni liste eklendikten sonra listeleri tekrar çek
      return _fetchLists(userId);
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
  Future<void> toggleWatchedStatus(int tmdbMovieId) async {
    final previousState = state;
    if (!state.hasValue) return;

    final lists = state.value!;
    
    // Find watched list
    MovieList? watchedList;
    try {
      watchedList = lists.firstWhere((l) => l.listType == 'watched');
    } catch (_) {
      watchedList = null;
    }

    bool isNewList = false;
    
    // Adım 1: Optimistic Update
    if (watchedList != null) {
      final updatedLists = lists.map((list) {
        if (list.id == watchedList!.id) {
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
    } else {
      isNewList = true;
      // List doesn't exist, create a temporary optimistic list
      final tempWatchedList = MovieList(
        id: 'temp_watched',
        userId: 'temp', // This will be overwritten by DB
        title: 'İzlediklerim',
        listType: 'watched',
        visibility: 'private',
        movieIds: [tmdbMovieId],
      );
      state = AsyncValue.data([tempWatchedList, ...lists]);
    }

    // Adım 2: Arka plan API isteği
    try {
      final repository = ref.read(listRepositoryProvider);
      
      if (isNewList) {
        // Create the list first
        final newList = await repository.createList('İzlediklerim', listType: 'watched');
        await repository.toggleMovieInList(newList.id, tmdbMovieId);
      } else {
        await repository.toggleMovieInList(watchedList!.id, tmdbMovieId);
      }

      // Sessizce gerçek veriyi tekrar çekip güncelleyelim (Silent sync)
      final updatedData = await _fetchLists(null);
      state = AsyncValue.data(updatedData);

    } catch (e, stack) {
      // Adım 3: Rollback & Hata Fırlatma
      // Hem eski duruma dön (previousState) hem de hata fırlat (UI için)
      if (previousState.hasValue) {
        state = AsyncValue<List<MovieList>>.error(e, stack).copyWithPrevious(previousState);
      } else {
        state = previousState;
      }
    }
  }

  /// Birden fazla filmi bir listeden toplu olarak kaldırır (Optimistic UI).
  Future<void> removeMultipleMoviesFromList(
    String listId,
    List<int> movieIds,
  ) async {
    final previousState = state;
    if (!state.hasValue) return;

    // Optimistic: State'ten anında çıkar
    final lists = state.value!;
    final updatedLists = lists.map((list) {
      if (list.id == listId) {
        final filtered = List<int>.from(list.movieIds)
          ..removeWhere((id) => movieIds.contains(id));
        return list.copyWith(movieIds: filtered);
      }
      return list;
    }).toList();
    state = AsyncValue.data(updatedLists);

    // Arkaplan: DB'den sil
    try {
      final repository = ref.read(listRepositoryProvider);
      await repository.removeMultipleMoviesFromList(listId, movieIds);
    } catch (e, stack) {
      // Rollback
      if (previousState.hasValue) {
        state = AsyncValue<List<MovieList>>.error(e, stack)
            .copyWithPrevious(previousState);
      } else {
        state = previousState;
      }
    }
  }

  /// Filmleri kaynak listeden hedef listeye taşır (Optimistic UI).
  Future<void> moveMoviesToAnotherList(
    String sourceListId,
    String targetListId,
    List<int> movieIds,
  ) async {
    final previousState = state;
    if (!state.hasValue) return;

    // Optimistic: Kaynaktan çıkar + Hedefe ekle
    final lists = state.value!;
    final updatedLists = lists.map((list) {
      if (list.id == sourceListId) {
        final filtered = List<int>.from(list.movieIds)
          ..removeWhere((id) => movieIds.contains(id));
        return list.copyWith(movieIds: filtered);
      }
      if (list.id == targetListId) {
        final merged = {...list.movieIds, ...movieIds}.toList();
        return list.copyWith(movieIds: merged);
      }
      return list;
    }).toList();
    state = AsyncValue.data(updatedLists);

    // Arkaplan: Atomik DB işlemi (sil + ekle)
    try {
      final repository = ref.read(listRepositoryProvider);
      await repository.removeMultipleMoviesFromList(sourceListId, movieIds);
      await repository.addMultipleMoviesToList(targetListId, movieIds);
    } catch (e, stack) {
      // Atomik Rollback: Tüm state eski haline döner
      if (previousState.hasValue) {
        state = AsyncValue<List<MovieList>>.error(e, stack)
            .copyWithPrevious(previousState);
      } else {
        state = previousState;
      }
    }
  }
}
