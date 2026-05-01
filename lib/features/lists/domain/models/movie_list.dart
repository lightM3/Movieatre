import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_list.freezed.dart';
part 'movie_list.g.dart';

@freezed
class MovieList with _$MovieList {
  const factory MovieList({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    @JsonKey(name: 'list_type') required String listType,
    required String visibility,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Ekstra alan: UI'da o listede kaç film olduğunu veya filmlerin listesini göstermek için kullanılabilir
    @JsonKey(includeFromJson: false, includeToJson: false) @Default([]) List<int> movieIds,
  }) = _MovieList;

  factory MovieList.fromJson(Map<String, dynamic> json) => _$MovieListFromJson(json);
}
