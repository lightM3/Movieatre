import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:go_router/go_router.dart';

import '../domain/movie_controller.dart';
import '../../auth/presentation/widgets/glass_container.dart';
import '../../../core/routing/route_names.dart';

class MoviesScreen extends ConsumerStatefulWidget {
  const MoviesScreen({super.key});

  @override
  ConsumerState<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends ConsumerState<MoviesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(popularMoviesProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesState = ref.watch(popularMoviesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Arka plan
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Popüler Filmler',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.white),
            onPressed: () {
              ref.read(popularMoviesProvider.notifier).shuffleAndReload();
            },
          )
        ],
      ),
      body: moviesState.when(
        data: (state) {
          final movies = state.movies;
          
          if (movies.isEmpty && !state.isLoadingMore) {
            return Center(
              child: Text(
                'Gösterilecek film yok.',
                style: GoogleFonts.inter(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: movies.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == movies.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.indigoAccent),
                  ),
                );
              }

              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteNames.movieDetail,
                      pathParameters: {'id': movie.id.toString()},
                    );
                  },
                  child: GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      if (movie.posterPath != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                            width: 80,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 120,
                              color: Colors.grey.withValues(alpha: 0.2),
                              child: const Icon(Icons.movie, color: Colors.white54),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.movie, color: Colors.white54),
                        ),
                      const SizedBox(width: 16),
                      
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (movie.releaseDate != null) ...[
                                  const SizedBox(width: 12),
                                  const Icon(Icons.calendar_today, color: Colors.white54, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    movie.releaseDate!.split('-').first,
                                    style: GoogleFonts.inter(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              movie.overview,
                              style: GoogleFonts.inter(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.indigoAccent),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Hata Oluştu',
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
                    ref.refresh(popularMoviesProvider);
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
