import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/movie_detail_controller.dart';
import '../domain/models/movie_detail.dart';
import '../../auth/presentation/widgets/glass_container.dart';
import '../../lists/presentation/widgets/add_to_list_bottom_sheet.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailState = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: movieDetailState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.indigoAccent),
        ),
        error: (error, stack) => _buildErrorState(context, ref, error),
        data: (movie) => _buildContent(context, movie),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              'Detaylar Yüklenemedi',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: GoogleFonts.inter(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // ignore: unused_result
                ref.refresh(movieDetailProvider(movieId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Tekrar Dene',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Geri Dön',
                style: GoogleFonts.inter(color: Colors.white70),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieDetail movie) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, movie),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMovieInfo(movie),
                const SizedBox(height: 24),
                _buildOverview(movie),
                const SizedBox(height: 32),
                if (movie.credits?.cast != null && movie.credits!.cast.isNotEmpty) ...[
                  _buildSectionTitle('Oyuncu Kadrosu'),
                  const SizedBox(height: 16),
                  _buildCastList(movie.credits!.cast),
                  const SizedBox(height: 32),
                ],
                if (movie.videos?.results != null && movie.videos!.results.isNotEmpty) ...[
                  _buildSectionTitle('Fragmanlar'),
                  const SizedBox(height: 16),
                  _buildTrailersList(movie.videos!.results),
                  const SizedBox(height: 32),
                ],
                _buildAddToListButton(context, movie.id),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, MovieDetail movie) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (movie.backdropPath != null)
              CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.withValues(alpha: 0.1),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white24),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.withValues(alpha: 0.1),
                  child: const Icon(Icons.image_not_supported, color: Colors.white54, size: 48),
                ),
              )
            else
              Container(
                color: Colors.grey.withValues(alpha: 0.1),
                child: const Icon(Icons.image_not_supported, color: Colors.white54, size: 48),
              ),
            // Gradient Overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black54,
                    Colors.transparent,
                    Color(0xFF0F172A),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo(MovieDetail movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: GoogleFonts.inter(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty) ...[
              const Icon(Icons.calendar_today, color: Colors.white54, size: 16),
              const SizedBox(width: 6),
              Text(
                movie.releaseDate!.split('-').first,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }

  Widget _buildOverview(MovieDetail movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Özet'),
        const SizedBox(height: 12),
        Text(
          movie.overview,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCastList(List<Cast> castList) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: castList.length,
        itemBuilder: (context, index) {
          final cast = castList[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 100,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: cast.profilePath != null
                        ? CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.withValues(alpha: 0.1),
                              child: const Icon(Icons.person, color: Colors.white24),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.withValues(alpha: 0.1),
                              child: const Icon(Icons.person, color: Colors.white24),
                            ),
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.withValues(alpha: 0.1),
                            child: const Icon(Icons.person, color: Colors.white24),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cast.name,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cast.character,
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrailersList(List<Video> videos) {
    final youtubeVideos = videos.where((v) => v.site.toLowerCase() == 'youtube').toList();

    if (youtubeVideos.isEmpty) {
      return Text(
        'Fragman bulunamadı.',
        style: GoogleFonts.inter(color: Colors.white54),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: youtubeVideos.length,
        itemBuilder: (context, index) {
          final video = youtubeVideos[index];
          final thumbnailUrl = 'https://img.youtube.com/vi/${video.key}/0.jpg';
          final youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=${video.key}');

          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async {
                try {
                  final launched = await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
                  if (!launched) {
                    await launchUrl(youtubeUrl, mode: LaunchMode.platformDefault);
                  }
                } catch (e) {
                  debugPrint('Video açılamadı: $e');
                }
              },
              child: SizedBox(
                width: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        width: 220,
                        height: 140,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 220,
                          height: 140,
                          color: Colors.grey.withValues(alpha: 0.1),
                          child: const Icon(Icons.movie, color: Colors.white24),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 220,
                          height: 140,
                          color: Colors.grey.withValues(alpha: 0.1),
                          child: const Icon(Icons.error_outline, color: Colors.white24),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        video.name,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          backgroundColor: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddToListButton(BuildContext context, int tmdbMovieId) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => FractionallySizedBox(
                heightFactor: 0.7,
                child: AddToListBottomSheet(tmdbMovieId: tmdbMovieId),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Listeye Ekle',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
