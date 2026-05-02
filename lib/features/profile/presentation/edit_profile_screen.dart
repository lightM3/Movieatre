import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../auth/presentation/widgets/glass_container.dart';
import '../../movies/domain/models/movie.dart';
import '../domain/edit_profile_controller.dart';
import '../domain/profile_controller.dart';
import 'widgets/movie_search_bottom_sheet.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _bioController = TextEditingController();
  final List<Movie?> _topFourMovies = List.filled(4, null);
  String? _avatarUrl;
  
  bool _isAvatarUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final profileState = ref.read(profileControllerProvider).valueOrNull;
    if (profileState != null) {
      _bioController.text = profileState.profile.bio ?? '';
      _avatarUrl = profileState.profile.avatarUrl;
      
      for (int i = 0; i < profileState.topFourMovies.length && i < 4; i++) {
        _topFourMovies[i] = profileState.topFourMovies[i];
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        _isAvatarUploading = true;
      });

      final file = File(image.path);
      final publicUrl = await ref.read(editProfileControllerProvider.notifier).uploadAvatar(file);
      
      if (mounted && publicUrl != null) {
        setState(() {
          _avatarUrl = publicUrl;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fotoğraf yüklenemedi: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAvatarUploading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    final List<int> top4Ids = _topFourMovies
        .where((m) => m != null)
        .map((m) => m!.id)
        .toList();

    try {
      await ref.read(editProfileControllerProvider.notifier).saveProfile(
        bio: _bioController.text,
        topFourMovies: top4Ids,
        avatarUrl: _avatarUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil başarıyla güncellendi!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil güncellenemedi: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _openMovieSearch(int index) async {
    final selectedMovie = await showModalBottomSheet<Movie>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MovieSearchBottomSheet(),
    );

    if (selectedMovie != null) {
      // Check for duplicates
      final isDuplicate = _topFourMovies.any((m) => m?.id == selectedMovie.id);
      if (isDuplicate) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bu film zaten favorilerinizde!'),
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
        return;
      }

      setState(() {
        _topFourMovies[index] = selectedMovie;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(editProfileControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Profili Düzenle',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: GestureDetector(
                  onTap: _isAvatarUploading ? null : _pickAndUploadAvatar,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigoAccent.withValues(alpha: 0.2),
                          border: Border.all(
                            color: Colors.indigoAccent.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: _avatarUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: _avatarUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.indigoAccent.withValues(alpha: 0.5),
                                ),
                        ),
                      ),
                      if (_isAvatarUploading)
                        const CircularProgressIndicator(color: Colors.white),
                      if (!_isAvatarUploading)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.indigoAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Bio
              Text(
                'Hakkımda',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _bioController,
                  style: GoogleFonts.inter(color: Colors.white),
                  maxLength: 160,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Kendinden ve film zevkinden bahset...',
                    hintStyle: GoogleFonts.inter(color: Colors.white38),
                    border: InputBorder.none,
                    counterStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Top 4
              Text(
                'Top 4 Favoriler',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  final movie = _topFourMovies[index];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _openMovieSearch(index),
                      child: Container(
                        margin: EdgeInsets.only(right: index == 3 ? 0 : 8),
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: movie?.posterPath != null
                              ? CachedNetworkImage(
                                  imageUrl: 'https://image.tmdb.org/t/p/w500${movie!.posterPath}',
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white.withValues(alpha: 0.3),
                                    size: 32,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: editState.isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: editState.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Değişiklikleri Kaydet',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
