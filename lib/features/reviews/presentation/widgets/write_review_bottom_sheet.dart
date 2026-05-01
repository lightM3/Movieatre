import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/review_controller.dart';
import '../../../../core/error/custom_exceptions.dart';

class WriteReviewBottomSheet extends ConsumerStatefulWidget {
  final int movieId;

  const WriteReviewBottomSheet({
    super.key,
    required this.movieId,
  });

  @override
  ConsumerState<WriteReviewBottomSheet> createState() => _WriteReviewBottomSheetState();
}

class _WriteReviewBottomSheetState extends ConsumerState<WriteReviewBottomSheet> {
  final _contentController = TextEditingController();
  double _rating = 0.0;
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir puan verin.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(movieReviewsControllerProvider(widget.movieId).notifier).addOrUpdateReview(
        _rating * 2,
        _contentController.text.trim(),
      );
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yorumunuz başarıyla kaydedildi!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is AppException ? e.message : 'Bir hata oluştu: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData iconData;
        
        // Yarım yıldız desteği (0.5, 1.0, 1.5...)
        // Kullanıcı yıldıza basılı tutup sürüklediğinde veya tıkladığında
        // yatay pozisyonuna göre buçuklu değer alabilir.
        // Şimdilik basitçe tıklama ile tam yıldız vereceğiz,
        // ama GestureDetector'ın onPanUpdate/onTapDown eventleri ile yarım yıldız destekleyelim.
        
        return GestureDetector(
          onTapDown: (details) {
            final localPosition = details.localPosition;
            // Eğer yıldızın sol yarısındaysa .5, sağ yarısındaysa tam puan
            final isHalf = localPosition.dx < 18.0; 
            setState(() {
              _rating = isHalf ? starValue - 0.5 : starValue.toDouble();
            });
          },
          onPanUpdate: (details) {
            final localPosition = details.localPosition;
            final isHalf = localPosition.dx < 18.0;
            setState(() {
              _rating = isHalf ? starValue - 0.5 : starValue.toDouble();
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Builder(
              builder: (context) {
                if (_rating >= starValue) {
                  iconData = Icons.star;
                } else if (_rating >= starValue - 0.5) {
                  iconData = Icons.star_half;
                } else {
                  iconData = Icons.star_border;
                }
                return Icon(
                  iconData,
                  color: Colors.amber,
                  size: 36,
                );
              },
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 5 yıldız = 10 puan (TMDB 10 üzerinden değerlendirir)
    // Gösterim için 5 üzerinden çalışıyoruz, API'ye gönderirken de isterseniz x2 yapabilirsiniz.
    // Şimdilik _rating değerini doğrudan kullanıyoruz (0.5 - 5 arası veya 1-10 arası, tasarınıza göre).
    // Kullanıcıya 10 üzerinden göstermek için _rating * 2 diyebiliriz.
    final displayRating = _rating * 2;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withValues(alpha: 0.85),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Değerlendir',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Puanlama
              _buildStarRating(),
              const SizedBox(height: 8),
              Text(
                _rating > 0 ? '${displayRating.toStringAsFixed(1)} / 10' : 'Puan vermek için dokunun',
                style: GoogleFonts.inter(
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Yorum Alanı
              TextField(
                controller: _contentController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Film hakkında ne düşünüyorsunuz? (Opsiyonel)',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.indigoAccent),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Gönder Butonu
              ElevatedButton(
                onPressed: _isLoading ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.indigoAccent.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Gönder',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
