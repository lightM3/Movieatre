import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../domain/list_detail_controller.dart';
import '../domain/list_controller.dart';
import '../../auth/presentation/widgets/glass_container.dart';
import '../../movies/domain/models/movie.dart';

class ListDetailScreen extends ConsumerStatefulWidget {
  final String listId;
  final String listTitle;

  const ListDetailScreen({
    super.key,
    required this.listId,
    required this.listTitle,
  });

  @override
  ConsumerState<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends ConsumerState<ListDetailScreen> {
  bool _isEditMode = false;
  final Set<int> _selectedMovieIds = {};

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) _selectedMovieIds.clear();
    });
  }

  void _toggleSelection(int movieId) {
    setState(() {
      if (_selectedMovieIds.contains(movieId)) {
        _selectedMovieIds.remove(movieId);
      } else {
        _selectedMovieIds.add(movieId);
      }
    });
  }

  void _handleRemove() {
    if (_selectedMovieIds.isEmpty) return;
    ref
        .read(listControllerProvider(null).notifier)
        .removeMultipleMoviesFromList(
          widget.listId,
          _selectedMovieIds.toList(),
        );
    _toggleEditMode();
  }

  void _handleMove() {
    if (_selectedMovieIds.isEmpty) return;
    _showMoveBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    final moviesState = ref.watch(listDetailControllerProvider(widget.listId));

    // Hata dinleyicisi (Rollback SnackBar)
    ref.listen(listControllerProvider(null), (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'İşlem başarısız oldu, değişiklikler geri alındı.',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              moviesState.when(
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child:
                        CircularProgressIndicator(color: Colors.indigoAccent),
                  ),
                ),
                error: (error, _) => SliverFillRemaining(
                  child: _buildErrorState(context, error),
                ),
                data: (movies) {
                  if (movies.isEmpty) {
                    return SliverFillRemaining(
                      child: _buildEmptyState(context),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      _isEditMode && _selectedMovieIds.isNotEmpty ? 100 : 32,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final movie = movies[index];
                          return _buildMovieCard(context, movie);
                        },
                        childCount: movies.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          // Bottom Action Bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () {
          if (_isEditMode) {
            _toggleEditMode();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: _toggleEditMode,
          child: Text(
            _isEditMode ? 'İptal' : 'Düzenle',
            style: GoogleFonts.inter(
              color: _isEditMode ? Colors.redAccent : Colors.indigoAccent,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16, right: 100),
        title: Text(
          _isEditMode && _selectedMovieIds.isNotEmpty
              ? '${_selectedMovieIds.length} Seçildi'
              : widget.listTitle,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.indigoAccent.withValues(alpha: 0.3),
                const Color(0xFF0F172A),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie) {
    final isSelected = _selectedMovieIds.contains(movie.id);

    return GestureDetector(
      onTap: () {
        if (_isEditMode) {
          _toggleSelection(movie.id);
        } else {
          context.pushNamed(
            RouteNames.movieDetail,
            pathParameters: {'id': movie.id.toString()},
          );
        }
      },
      onLongPress: () {
        if (!_isEditMode) {
          _toggleEditMode();
          _toggleSelection(movie.id);
        }
      },
      child: Stack(
        children: [
          GlassContainer(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: movie.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.white.withValues(alpha: 0.05),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white24,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.white.withValues(alpha: 0.05),
                              child: const Icon(
                                Icons.movie,
                                color: Colors.white24,
                                size: 40,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.white.withValues(alpha: 0.05),
                            child: const Center(
                              child: Icon(
                                Icons.movie,
                                color: Colors.white24,
                                size: 40,
                              ),
                            ),
                          ),
                  ),
                ),
                // Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Selection Overlay
          if (_isEditMode)
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: isSelected
                      ? Colors.indigoAccent.withValues(alpha: 0.4)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(color: Colors.indigoAccent, width: 2.5)
                      : null,
                ),
                child: isSelected
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.indigoAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final isVisible = _isEditMode && _selectedMovieIds.isNotEmpty;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      left: 16,
      right: 16,
      bottom: isVisible ? 24 : -100,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isVisible ? 1.0 : 0.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  // Kaldır Butonu
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.delete_outline,
                      label: 'Kaldır',
                      color: Colors.redAccent,
                      onTap: _handleRemove,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  // Taşı Butonu
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.drive_file_move_outline,
                      label: 'Taşı',
                      color: Colors.indigoAccent,
                      onTap: _handleMove,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoveBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, sheetRef, _) {
            final listsState = sheetRef.watch(listControllerProvider(null));

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Hangi listeye taşımak istiyorsun?',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  Flexible(
                    child: listsState.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(
                            color: Colors.indigoAccent,
                          ),
                        ),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Listeler yüklenemedi: $e',
                          style:
                              GoogleFonts.inter(color: Colors.white54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      data: (lists) {
                        // Mevcut listeyi filtrele
                        final otherLists = lists
                            .where((l) => l.id != widget.listId)
                            .toList();

                        if (otherLists.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.playlist_add,
                                  color: Colors.white38,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Taşıyabileceğin başka bir listen yok.\nÖnce yeni bir liste oluştur.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: otherLists.length,
                          separatorBuilder: (_, _) => const Divider(
                            color: Colors.white12,
                            height: 1,
                            indent: 56,
                          ),
                          itemBuilder: (context, index) {
                            final targetList = otherLists[index];
                            return ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.indigoAccent
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.list_alt,
                                  color: Colors.indigoAccent,
                                  size: 22,
                                ),
                              ),
                              title: Text(
                                targetList.title,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${targetList.movieIds.length} film',
                                style: GoogleFonts.inter(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white38,
                                size: 16,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                ref
                                    .read(listControllerProvider(null).notifier)
                                    .moveMoviesToAnotherList(
                                      widget.listId,
                                      targetList.id,
                                      _selectedMovieIds.toList(),
                                    );
                                _toggleEditMode();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.indigoAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.indigoAccent.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.movie_filter_outlined,
                color: Colors.indigoAccent,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bu liste henüz boş',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Hemen film keşfetmeye başla\nve bu listeye favori filmlerini ekle!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => context.goNamed(RouteNames.home),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.indigoAccent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.explore_outlined,
                          color: Colors.indigoAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Film Keşfet',
                          style: GoogleFonts.inter(
                            color: Colors.indigoAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Filmler Yüklenemedi',
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ref
                    .read(
                      listDetailControllerProvider(widget.listId).notifier,
                    )
                    .refresh();
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'Tekrar Dene',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
