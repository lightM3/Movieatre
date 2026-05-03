import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/error/custom_exceptions.dart';
import '../../domain/models/movie_list.dart';
import '../../domain/models/movie_list_item.dart';

part 'list_repository.g.dart';

class ListRepository {
  final SupabaseClient _supabase;

  ListRepository(this._supabase);

  Future<List<MovieList>> getUserLists([String? userId]) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      final targetUserId = userId ?? currentUserId;
      if (targetUserId == null) throw AuthException('Oturum bulunamadı.');

      // Listeleri getir
      final listsResponse = await _supabase
          .from('lists')
          .select()
          .eq('user_id', targetUserId)
          .order('created_at', ascending: false);

      final lists = (listsResponse as List)
          .map((e) => MovieList.fromJson(e))
          .toList();

      // İlgili listelerin öğelerini (filmleri) de getir
      if (lists.isNotEmpty) {
        final listIds = lists.map((l) => l.id).toList();
        final itemsResponse = await _supabase
            .from('list_items')
            .select()
            .inFilter('list_id', listIds);

        final items = (itemsResponse as List)
            .map((e) => MovieListItem.fromJson(e))
            .toList();

        // Her liste için movieIds alanını doldur
        return lists.map((list) {
          final listItems = items
              .where((i) => i.listId == list.id)
              .map((i) => i.tmdbMovieId)
              .toList();
          return list.copyWith(movieIds: listItems);
        }).toList();
      }

      return lists;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw DatabaseException('Listeler yüklenemedi: $e');
    }
  }

  Future<MovieList> createList(
    String title, {
    String listType = 'custom',
    String visibility = 'private',
    String? description,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw AuthException('Oturum bulunamadı.');

      final response = await _supabase
          .from('lists')
          .insert({
            'user_id': userId,
            'title': title,
            'list_type': listType,
            'visibility': visibility,
            if (description != null) 'description': description,
          })
          .select()
          .single();

      return MovieList.fromJson(response);
    } catch (e) {
      throw DatabaseException('Liste oluşturulamadı: $e');
    }
  }

  Future<void> toggleMovieInList(String listId, int tmdbMovieId) async {
    try {
      // Önce bu filmin listede olup olmadığına bakalım
      final existingResponse = await _supabase
          .from('list_items')
          .select()
          .eq('list_id', listId)
          .eq('tmdb_movie_id', tmdbMovieId)
          .maybeSingle();

      if (existingResponse != null) {
        // Varsa sil (Kaldır)
        await _supabase
            .from('list_items')
            .delete()
            .eq('id', existingResponse['id']);
      } else {
        // Yoksa ekle
        await _supabase.from('list_items').insert({
          'list_id': listId,
          'tmdb_movie_id': tmdbMovieId,
        });
      }
    } catch (e) {
      throw DatabaseException('Film listeye eklenemedi/çıkarılamadı: $e');
    }
  }
}

@riverpod
ListRepository listRepository(ListRepositoryRef ref) {
  return ListRepository(ref.watch(supabaseClientProvider));
}
