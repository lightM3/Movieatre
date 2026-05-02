import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/profile_repository.dart';
import 'profile_controller.dart';

part 'edit_profile_controller.g.dart';

@riverpod
class EditProfileController extends _$EditProfileController {
  @override
  FutureOr<void> build() {}

  Future<String?> uploadAvatar(File imageFile) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(profileRepositoryProvider);
      final publicUrl = await repository.uploadAvatar(imageFile);
      state = const AsyncValue.data(null);
      return publicUrl;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> saveProfile({String? bio, List<int>? topFourMovies, String? avatarUrl}) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.updateProfile(
        bio: bio,
        topFourMovies: topFourMovies,
        avatarUrl: avatarUrl,
      );
      
      // Kayıt başarılıysa profile sayfasındaki controller'ı yenile ki yeni verileri çeksin
      ref.invalidate(profileControllerProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
