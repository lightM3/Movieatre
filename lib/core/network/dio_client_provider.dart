import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../env/env_config.dart';

part 'dio_client_provider.g.dart';

@riverpod
Dio dioClient(DioClientRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.tmdbBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // TMDB v3 API için query parameter olarak api_key ekle
        options.queryParameters['api_key'] = EnvConfig.tmdbApiKey;
        return handler.next(options);
      },
    ),
  );

  return dio;
}
