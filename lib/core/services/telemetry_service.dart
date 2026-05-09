import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'telemetry_service.g.dart';

/// Uygulamanın telemetri (Analitik ve Çökme/Hata takibi) işlemlerini
/// soyutlayan arayüz.
abstract class ITelemetryService {
  /// Kullanıcının görüntülediği sayfayı loglar.
  Future<void> logScreenView(String screenName);

  /// Özel bir aksiyon/etkinlik (event) gerçekleştiğinde loglar.
  Future<void> logEvent(String eventName, {Map<String, Object>? parameters});

  /// Kritik olan veya olmayan uygulama hatalarını Crashlytics'e raporlar.
  Future<void> recordError(dynamic exception, StackTrace stackTrace, {dynamic reason});

  /// Telemetri verilerini spesifik bir kullanıcı kimliği ile eşleştirir.
  Future<void> setUserId(String userId);
}

/// Firebase tabanlı telemetri servisi implementasyonu.
/// Ana uygulamanın çökmesini önlemek için tüm çağrılar [try-catch] ile sarmalanmıştır.
class FirebaseTelemetryService implements ITelemetryService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  @override
  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (e) {
      debugPrint('Telemetry Error (logScreenView): $e');
    }
  }

  @override
  Future<void> logEvent(String eventName, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(name: eventName, parameters: parameters);
    } catch (e) {
      debugPrint('Telemetry Error (logEvent): $e');
    }
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace stackTrace, {dynamic reason}) async {
    try {
      await _crashlytics.recordError(
        exception, 
        stackTrace, 
        reason: reason,
        printDetails: kDebugMode, // Sadece debug modunda konsola ek detay bas.
      );
    } catch (e) {
      debugPrint('Telemetry Error (recordError): $e');
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
      await _analytics.setUserId(id: userId);
    } catch (e) {
      debugPrint('Telemetry Error (setUserId): $e');
    }
  }
}

/// [FirebaseTelemetryService] instance'ını sağlayan Riverpod provider'ı.
@Riverpod(keepAlive: true)
ITelemetryService telemetryService(TelemetryServiceRef ref) {
  return FirebaseTelemetryService();
}
