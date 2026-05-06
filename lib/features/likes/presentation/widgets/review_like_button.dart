import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/like_controller.dart';

class ReviewLikeButton extends ConsumerStatefulWidget {
  final String reviewId;

  const ReviewLikeButton({super.key, required this.reviewId});

  @override
  ConsumerState<ReviewLikeButton> createState() => _ReviewLikeButtonState();
}

class _ReviewLikeButtonState extends ConsumerState<ReviewLikeButton> {
  @override
  void initState() {
    super.initState();
    // Sayfa/Kart yüklendiğinde like durumunu çek
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(likeControllerProvider.notifier).fetchLikeState(widget.reviewId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final likeState = ref.watch(likeControllerProvider);
    final isLiked = likeState.isLikedMap[widget.reviewId] ?? false;
    final likeCount = likeState.likeCountMap[widget.reviewId] ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () async {
            try {
              await ref
                  .read(likeControllerProvider.notifier)
                  .toggleLike(widget.reviewId);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Beğeni işlemi başarısız: $e'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          },
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.redAccent : Colors.white54,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 24,
        ),
        if (likeCount > 0) ...[
          const SizedBox(width: 6),
          Text(
            '$likeCount',
            style: GoogleFonts.inter(
              color: isLiked ? Colors.redAccent : Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]
      ],
    );
  }
}
