import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/error/custom_exceptions.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository(this._supabase);

  Future<String> uploadAvatar(File imageFile) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw AuthException('Oturum bulunamadı');

      // Sıkıştırma (P0 Kuralı)
      final targetPath = '${imageFile.parent.path}/compressed_$userId.jpg';
      var result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: 70, // %70 kalite ile sıkıştırıyoruz
        minWidth: 500,
        minHeight: 500,
      );

      final fileToUpload = result != null ? File(result.path) : imageFile;

      final path = '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await _supabase.storage.from('avatars').upload(
        path,
        fileToUpload,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      final String publicUrl = _supabase.storage.from('avatars').getPublicUrl(path);

      // Temizlik (Oluşturulan geçici compress dosyasını sil)
      if (result != null && await File(result.path).exists()) {
        await File(result.path).delete();
      }

      return publicUrl;
    } on StorageException catch (e) {
      throw DatabaseException('Storage Hatası: ${e.message}');
    } catch (e) {
      throw DatabaseException('Resim yüklenirken bir hata oluştu: $e');
    }
  }

  Future<void> updateProfile({String? bio, List<int>? topFourMovies, String? avatarUrl}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw AuthException('Oturum bulunamadı');

      final updates = <String, dynamic>{};
      if (bio != null) updates['bio'] = bio;
      if (topFourMovies != null) updates['top_four_movies'] = topFourMovies;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      if (updates.isEmpty) return;

      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw DatabaseException('Profil güncellenemedi: $e');
    }
  }
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(ref.watch(supabaseClientProvider));
}
