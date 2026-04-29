import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../env/env_config.dart';
import '../error/custom_exceptions.dart';

part 'supabase_client_provider.g.dart';

class SupabaseInit {
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        anonKey: EnvConfig.supabaseAnonKey,
      );
    } catch (e) {
      throw DatabaseException('Supabase başlatılırken bir hata oluştu: $e');
    }
  }
}

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  try {
    return Supabase.instance.client;
  } catch (e) {
    throw DatabaseException('Supabase client alınamadı. Initialize edildiğinden emin olun. Detay: $e');
  }
}
