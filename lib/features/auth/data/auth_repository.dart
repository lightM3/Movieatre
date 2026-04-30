import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../core/error/custom_exceptions.dart' as app_errors;
import '../../../core/network/supabase_client_provider.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final supabase.SupabaseClient _supabase;

  AuthRepository(this._supabase);

  Future<void> signIn(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on supabase.AuthException catch (e) {
      throw app_errors.AuthException(e.message, code: e.statusCode);
    } catch (e) {
      throw app_errors.NetworkException('Giriş yapılırken bir hata oluştu: $e');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
      );
    } on supabase.AuthException catch (e) {
      throw app_errors.AuthException(e.message, code: e.statusCode);
    } catch (e) {
      throw app_errors.NetworkException('Kayıt olurken bir hata oluştu: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw app_errors.NetworkException('Çıkış yapılırken bir hata oluştu: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on supabase.AuthException catch (e) {
      throw app_errors.AuthException(e.message, code: e.statusCode);
    } catch (e) {
      throw app_errors.NetworkException('Şifre sıfırlama e-postası gönderilirken bir hata oluştu: $e');
    }
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
}
