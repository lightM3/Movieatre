import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/date_extensions.dart';
import '../../auth/presentation/widgets/glass_container.dart';
import '../domain/feed_controller.dart';
import '../../reviews/domain/models/review.dart';
import '../../movies/domain/models/movie.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Sosyal',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: feedState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.indigoAccent),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                'Akış yüklenemedi:\n$error',
                style: GoogleFonts.inter(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(feedControllerProvider),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
                child: const Text('Tekrar Dene', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        data: (state) {
          if (state.reviews.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(feedControllerProvider);
              try {
                await ref.read(feedControllerProvider.future);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Akış yenilenemedi: $e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            color: Colors.indigoAccent,
            backgroundColor: const Color(0xFF1E293B),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: state.reviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final review = state.reviews[index];
                final movie = state.movies[review.tmdbMovieId];
                return _buildFeedCard(context, review, movie);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.indigoAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_alt_outlined,
                color: Colors.indigoAccent,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz buralar çok sessiz.',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Keşfet sekmesinden filmlere yorum yapanları bulup takip edebilirsin!',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Keşfet (Home) sekmesine yönlendir (index 0)
                context.go(RoutePaths.home);
              },
              icon: const Icon(Icons.explore),
              label: const Text('Keşfetmeye Başla'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedCard(BuildContext context, Review review, Movie? movie) {
    final userName = review.profiles?.email?.split('@').first ?? 'Kullanıcı';
    final userAvatar = review.profiles?.avatarUrl;
    
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, İsmi, Film İsmi ve Zaman
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  context.pushNamed(RouteNames.userProfile, pathParameters: {'id': review.userId});
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigoAccent.withValues(alpha: 0.2),
                    border: Border.all(
                      color: Colors.indigoAccent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: ClipOval(
                    child: userAvatar != null
                        ? CachedNetworkImage(
                            imageUrl: userAvatar,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              userName[0].toUpperCase(),
                              style: GoogleFonts.outfit(
                                color: Colors.indigoAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                        children: [
                          TextSpan(
                            text: userName,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const TextSpan(text: ' bir filmi değerlendirdi.'),
                        ],
                      ),
                    ),
                    if (review.createdAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        review.createdAt!.toTimeAgo(),
                        style: GoogleFonts.inter(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Gövde: Afiş, Yıldızlar ve Yorum Metni
          GestureDetector(
            onTap: () {
              context.pushNamed(
                RouteNames.movieDetail, 
                pathParameters: {'id': review.tmdbMovieId.toString()}
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Film Afişi
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: movie?.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w500${movie!.posterPath}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(color: Colors.indigoAccent),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.movie, color: Colors.white38),
                          )
                        : const Icon(Icons.movie, color: Colors.white38),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Puan ve Yorum
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Film İsmi
                      if (movie != null) ...[
                        Text(
                          movie.title,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                      ],
                      // Yıldızlar
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < review.rating.floor()
                                  ? Icons.star
                                  : index < review.rating
                                      ? Icons.star_half
                                      : Icons.star_border,
                              color: Colors.amber,
                              size: 18,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            review.rating.toStringAsFixed(1),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Yorum Metni
                      if (review.content != null && review.content!.isNotEmpty)
                        Text(
                          review.content!,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
