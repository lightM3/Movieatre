import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_list_item.freezed.dart';
part 'movie_list_item.g.dart';

@freezed
class MovieListItem with _$MovieListItem {
  const factory MovieListItem({
    required String id,
    @JsonKey(name: 'list_id') required String listId,
    @JsonKey(name: 'tmdb_movie_id') required int tmdbMovieId,
    @JsonKey(name: 'added_at') DateTime? addedAt,
  }) = _MovieListItem;

  factory MovieListItem.fromJson(Map<String, dynamic> json) => _$MovieListItemFromJson(json);
}
