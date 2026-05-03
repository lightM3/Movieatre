import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/follow_repository.dart';

part 'follow_controller.g.dart';

@riverpod
class FollowController extends _$FollowController {
  @override
  FutureOr<bool> build(String targetUserId) async {
    return _fetchIsFollowing();
  }

  Future<bool> _fetchIsFollowing() async {
    final repo = ref.read(followRepositoryProvider);
    return repo.checkIsFollowing(targetUserId);
  }

  Future<void> toggleFollow() async {
    final previousState = state;
    final isCurrentlyFollowing = state.valueOrNull ?? false;

    // Optimistic Update: Hemen UI'ı güncelliyoruz
    state = AsyncValue.data(!isCurrentlyFollowing);

    try {
      final repo = ref.read(followRepositoryProvider);
      if (isCurrentlyFollowing) {
        await repo.unfollowUser(targetUserId);
      } else {
        await repo.followUser(targetUserId);
      }
      
      // İsterseniz tekrar senkronize edebilirsiniz
      // state = AsyncValue.data(await repo.checkIsFollowing(targetUserId));
    } catch (e, st) {
      // Hata durumunda state'i geri al ve hatayı fırlat
      state = previousState;
      rethrow;
    }
  }
}
