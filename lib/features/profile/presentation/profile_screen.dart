
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/routing/route_names.dart';
import '../../../core/network/supabase_client_provider.dart';
import '../../auth/domain/auth_controller.dart';
import '../../auth/presentation/widgets/glass_container.dart';
import '../../lists/domain/list_controller.dart';
import '../../movies/domain/models/movie.dart';
import '../domain/profile_controller.dart';
import '../domain/follow_controller.dart';

class ProfileScreen extends ConsumerWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider(userId));
    final listsState = ref.watch(listControllerProvider(userId));

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: userId != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'Profil',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: profileState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.indigoAccent),
          ),
          error: (error, _) => Center(
            child: Text(
              'Profil yüklenemedi: $error',
              style: GoogleFonts.inter(color: Colors.redAccent),
            ),
          ),
          data: (data) => SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Bottom nav bar için boşluk
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref, data),
                const SizedBox(height: 32),
                
                // Top 4 Favoriler
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Top 4 Favoriler',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTopFour(context, data.topFourMovies),
                const SizedBox(height: 32),
                
                // Listelerim
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Listelerim',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                listsState.when(
                  data: (lists) => _buildUserLists(lists),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: CircularProgressIndicator(color: Colors.indigoAccent),
                  ),
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text('Hata: $err', style: const TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Son Hareketler
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Son Hareketler',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRecentActivity(context, data.recentReviews),
                const SizedBox(height: 48),
                
                // Çıkış Butonu
                _buildLogoutButton(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, ProfileState data) {
    final profile = data.profile;
    final email = profile.email ?? 'Kullanıcı';
    final name = email.split('@').first;
    
    final currentUserId = ref.read(supabaseClientProvider).auth.currentUser?.id;
    final isCurrentUser = currentUserId == profile.id;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigoAccent.withValues(alpha: 0.2),
                  ),
                  child: ClipOval(
                    child: profile.avatarUrl != null
                        ? CachedNetworkImage(
                            imageUrl: profile.avatarUrl!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              name[0].toUpperCase(),
                              style: GoogleFonts.outfit(
                                color: Colors.indigoAccent,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${data.followersCount} Takipçi · ${data.followingCount} Takip Edilen',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentUser)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70),
                    onPressed: () => context.pushNamed(RouteNames.editProfile),
                  )
                else
                  _buildFollowButton(context, ref, profile.id),
              ],
            ),
            if (profile.bio != null && profile.bio!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  profile.bio!,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context, WidgetRef ref, String targetUserId) {
    final followState = ref.watch(followControllerProvider(targetUserId));
    
    return followState.when(
      data: (isFollowing) {
        return ElevatedButton(
          onPressed: () async {
            try {
              await ref.read(followControllerProvider(targetUserId).notifier).toggleFollow();
              // After follow/unfollow, we should ideally invalidate the profile controller to refresh stats
              ref.invalidate(profileControllerProvider(targetUserId));
              ref.invalidate(profileControllerProvider(null)); // Refresh current user's profile stats (following count)
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing ? Colors.white.withValues(alpha: 0.1) : Colors.indigoAccent,
            foregroundColor: isFollowing ? Colors.white : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: isFollowing 
                  ? BorderSide(color: Colors.white.withValues(alpha: 0.2))
                  : BorderSide.none,
            ),
            elevation: isFollowing ? 0 : 4,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            isFollowing ? 'Takip Ediliyor' : 'Takip Et',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        width: 100,
        height: 36,
        child: Center(child: CircularProgressIndicator(color: Colors.indigoAccent, strokeWidth: 2)),
      ),
      error: (error, stack) => const SizedBox(),
    );
  }

  Widget _buildTopFour(BuildContext context, List<Movie> movies) {
    if (movies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Henüz favori eklenmemiş.',
              style: GoogleFonts.inter(color: Colors.white54),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                RouteNames.movieDetail,
                pathParameters: {'id': movie.id.toString()},
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: movie.posterPath != null
                  ? CachedNetworkImage(
                      width: 120,
                      imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 120,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 120,
                        color: Colors.white.withValues(alpha: 0.05),
                        child: const Icon(Icons.error, color: Colors.white38),
                      ),
                    )
                  : Container(
                      width: 120,
                      color: Colors.white.withValues(alpha: 0.05),
                      child: const Icon(Icons.movie, color: Colors.white38),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserLists(List<dynamic> lists) {
    if (lists.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          'Hiç liste bulunamadı.',
          style: GoogleFonts.inter(color: Colors.white54),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: lists.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final list = lists[index];
          return GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.list_alt, color: Colors.indigoAccent),
                const SizedBox(height: 8),
                Text(
                  list.title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, List<ReviewWithMovie> activities) {
    if (activities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          'Henüz hareket bulunmuyor.',
          style: GoogleFonts.inter(color: Colors.white54),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: activities.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final activity = activities[index];
          final movie = activity.movie;
          
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                RouteNames.movieDetail,
                pathParameters: {'id': activity.review.tmdbMovieId.toString()},
              );
            },
            child: SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: movie?.posterPath != null
                        ? CachedNetworkImage(
                            height: 180,
                            width: 120,
                            imageUrl: 'https://image.tmdb.org/t/p/w500${movie!.posterPath}',
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 180,
                            width: 120,
                            color: Colors.white.withValues(alpha: 0.05),
                            child: const Icon(Icons.movie, color: Colors.white38),
                          ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        activity.review.rating.toStringAsFixed(1),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.goNamed(RouteNames.login);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: Colors.redAccent),
                const SizedBox(width: 12),
                Text(
                  'Çıkış Yap',
                  style: GoogleFonts.inter(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
