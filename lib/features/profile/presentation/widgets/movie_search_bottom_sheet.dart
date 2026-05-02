import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../auth/presentation/widgets/glass_container.dart';
import '../../../movies/domain/models/movie.dart';
import '../../../search/domain/search_controller.dart' as sc;

class MovieSearchBottomSheet extends ConsumerWidget {
  const MovieSearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Aynı searchControllerProvider'ı kullanıyoruz. 
    // Alt çizgi ile kendi dosyasındaki import çakışmasın diye 'sc' alias'ı kullandık.
    final searchState = ref.watch(sc.searchControllerProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withValues(alpha: 0.05),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Top 4 İçin Film Ara',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSearchBar(ref),
                const SizedBox(height: 16),
                Expanded(
                  child: searchState.when(
                    data: (movies) {
                      if (movies.isEmpty) {
                        return _buildEmptyState();
                      }
                      return _buildSearchResults(movies);
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.indigoAccent),
                    ),
                    error: (error, _) => Center(
                      child: Text(
                        'Hata oluştu: $error',
                        style: GoogleFonts.inter(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        style: GoogleFonts.inter(color: Colors.white),
        onChanged: (value) {
          ref.read(sc.searchControllerProvider.notifier).searchMovies(value);
        },
        decoration: InputDecoration(
          hintText: 'Film ara...',
          hintStyle: GoogleFonts.inter(color: Colors.white38),
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Colors.indigoAccent),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 64,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Film arayın...',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Movie> movies) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieCard(context, movie);
      },
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(movie); // Seçilen filmi geriye döndür
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: movie.posterPath != null
              ? CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.white.withValues(alpha: 0.05),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.white.withValues(alpha: 0.05),
                    child: const Icon(Icons.error_outline, color: Colors.white38),
                  ),
                )
              : Container(
                  height: 200,
                  color: Colors.white.withValues(alpha: 0.05),
                  child: const Center(
                    child: Icon(Icons.movie, color: Colors.white38, size: 48),
                  ),
                ),
        ),
      ),
    );
  }
}
