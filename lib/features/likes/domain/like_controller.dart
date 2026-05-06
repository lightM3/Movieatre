import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/domain/auth_controller.dart';
import '../data/repositories/like_repository.dart';

part 'like_controller.g.dart';

class LikeState {
  final Map<String, bool> isLikedMap;
  final Map<String, int> likeCountMap;

  LikeState({
    required this.isLikedMap,
    required this.likeCountMap,
  });

  LikeState copyWith({
    Map<String, bool>? isLikedMap,
    Map<String, int>? likeCountMap,
  }) {
    return LikeState(
      isLikedMap: isLikedMap ?? this.isLikedMap,
      likeCountMap: likeCountMap ?? this.likeCountMap,
    );
  }
}

@Riverpod(keepAlive: true)
class LikeController extends _$LikeController {
  @override
  LikeState build() {
    return LikeState(isLikedMap: {}, likeCountMap: {});
  }

  Future<void> fetchLikeState(String reviewId) async {
    final authState = ref.read(authStateProvider);
    final user = authState.value;
    if (user == null) return;

    try {
      final repo = ref.read(likeRepositoryProvider);
      final result = await repo.getLikeState(reviewId, user.id);

      final newIsLikedMap = Map<String, bool>.from(state.isLikedMap);
      final newLikeCountMap = Map<String, int>.from(state.likeCountMap);

      newIsLikedMap[reviewId] = result.isLiked;
      newLikeCountMap[reviewId] = result.likeCount;

      state = state.copyWith(
        isLikedMap: newIsLikedMap,
        likeCountMap: newLikeCountMap,
      );
    } catch (e) {
      // Sadece fetch hatası. Sessizce geçebiliriz veya loglayabiliriz.
    }
  }

  Future<void> toggleLike(String reviewId) async {
    final authState = ref.read(authStateProvider);
    final user = authState.value;
    if (user == null) throw Exception('Kullanıcı oturumu yok.');

    final currentIsLiked = state.isLikedMap[reviewId] ?? false;
    final currentCount = state.likeCountMap[reviewId] ?? 0;

    // Optimistic Update (İyimser Güncelleme)
    final newIsLiked = !currentIsLiked;
    final newCount = newIsLiked ? currentCount + 1 : currentCount - 1;

    final newIsLikedMap = Map<String, bool>.from(state.isLikedMap);
    final newLikeCountMap = Map<String, int>.from(state.likeCountMap);

    newIsLikedMap[reviewId] = newIsLiked;
    newLikeCountMap[reviewId] = newCount;

    state = state.copyWith(
      isLikedMap: newIsLikedMap,
      likeCountMap: newLikeCountMap,
    );

    try {
      final repo = ref.read(likeRepositoryProvider);
      await repo.toggleLike(reviewId, user.id, currentIsLiked);
    } catch (e) {
      // Hata durumunda Rollback (Geri al)
      final rollbackIsLikedMap = Map<String, bool>.from(state.isLikedMap);
      final rollbackLikeCountMap = Map<String, int>.from(state.likeCountMap);

      rollbackIsLikedMap[reviewId] = currentIsLiked;
      rollbackLikeCountMap[reviewId] = currentCount;

      state = state.copyWith(
        isLikedMap: rollbackIsLikedMap,
        likeCountMap: rollbackLikeCountMap,
      );
      
      // Hatayı UI'a fırlat ki SnackBar gösterebilelim
      rethrow;
    }
  }
}
