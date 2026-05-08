import 'package:movietre/features/profile/domain/profile_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/follow_repository.dart';

part 'follow_controller.g.dart';

@riverpod
class FollowController extends _$FollowController {
  bool _isProcessing = false;

  @override
  FutureOr<bool> build(String targetUserId) async {
    return _fetchIsFollowing();
  }

  Future<bool> _fetchIsFollowing() async {
    final repo = ref.read(followRepositoryProvider);
    final result = await repo.checkIsFollowing(targetUserId);
    return result;
  }

  Future<void> toggleFollow() async {
    if (_isProcessing) return;

    _isProcessing = true;
    final previousState = state;
    final isCurrentlyFollowing = state.valueOrNull ?? false;
    final targetState = !isCurrentlyFollowing;

    state = AsyncValue.data(targetState);

    try {
      final repo = ref.read(followRepositoryProvider);
      if (targetState) {
        await repo.followUser(targetUserId);
      } else {
        await repo.unfollowUser(targetUserId);
      }

      final actualState = await repo.checkIsFollowing(targetUserId);
      state = AsyncValue.data(actualState);

      ref.invalidate(profileControllerProvider(targetUserId));
    } catch (e) {
      try {
        final repo = ref.read(followRepositoryProvider);
        final actualState = await repo.checkIsFollowing(targetUserId);
        state = AsyncValue.data(actualState);
      } catch (_) {
        state = previousState;
      }
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }
}
