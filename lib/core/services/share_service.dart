import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'share_service.g.dart';

/// Uygulama içi yerel paylaşım (Native Share) işlemlerini yöneten arayüz.
abstract class IShareService {
  /// Verilen filmi cihazın yerel paylaşım menüsü üzerinden paylaşır.
  Future<void> shareMovie(String movieId, String movieTitle);

  /// Verilen kullanıcı profilini cihazın yerel paylaşım menüsü üzerinden paylaşır.
  Future<void> shareProfile(String profileId, String userName);
}

/// [IShareService] arayüzünün share_plus tabanlı somut (concrete) implementasyonu.
class ShareService implements IShareService {
  @override
  Future<void> shareMovie(String movieId, String movieTitle) async {
    try {
      final shareText = 
          'Şu filme kesinlikle göz atmalısın: $movieTitle 🎬\n\nHemen İncele: https://movietre.app/movie/$movieId';
      
      // share_plus paketini çağırıyoruz
      await Share.share(shareText);
    } catch (e) {
      debugPrint('Film paylaşım hatası: $e');
      // İsteğe bağlı olarak burada AppException fırlatılıp UI'da SnackBar ile gösterilebilir,
      // ancak native share menüsünün açılamaması kritik olmayan bir durum olduğu için
      // sessizce loglayıp yutmayı tercih ediyoruz (Production-ready robust yaklaşım).
    }
  }

  @override
  Future<void> shareProfile(String profileId, String userName) async {
    try {
      final shareText = 
          '$userName profilini incele! Harika film zevkleri var. 🍿\n\nHemen İncele: https://movietre.app/profile/$profileId';
      
      await Share.share(shareText);
    } catch (e) {
      debugPrint('Profil paylaşım hatası: $e');
    }
  }
}

/// [ShareService] instance'ını sağlayan global Riverpod provider'ı.
@riverpod
IShareService shareService(ShareServiceRef ref) {
  return ShareService();
}
