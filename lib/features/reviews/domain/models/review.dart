import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'tmdb_movie_id') required int tmdbMovieId,
    required double rating,
    String? content,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Join işlemiyle profile eklenebilir
    Profile? profiles, 
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
