import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/review.dart';
import '../data/repositories/review_repository.dart';

part 'review_controller.g.dart';

@riverpod
class MovieReviewsController extends _$MovieReviewsController {
  @override
  FutureOr<List<Review>> build(int movieId) async {
    return ref.read(reviewRepositoryProvider).getMovieReviews(movieId);
  }

  Future<void> addOrUpdateReview(double rating, String? content) async {
    final previousState = state;
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(reviewRepositoryProvider);
      await repository.addOrUpdateReview(movieId, rating, content);
      // Başarılı olursa listeyi yeniden çek
      state = AsyncValue.data(await repository.getMovieReviews(movieId));
    } catch (e, st) {
      state = previousState;
      // UI tarafında hatayı yakalamak için exception fırlatmaya devam edebiliriz
      // veya throw error yaparak UI'daki submit butonunun catch bloğuna düşmesini sağlayabiliriz.
      Error.throwWithStackTrace(e, st);
    }
  }
}
