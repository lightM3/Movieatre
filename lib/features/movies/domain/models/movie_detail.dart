import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail.freezed.dart';
part 'movie_detail.g.dart';

@freezed
class MovieDetail with _$MovieDetail {
  const factory MovieDetail({
    required int id,
    required String title,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    required String overview,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') String? releaseDate,
    Credits? credits,
    Videos? videos,
  }) = _MovieDetail;

  factory MovieDetail.fromJson(Map<String, dynamic> json) => _$MovieDetailFromJson(json);
}

@freezed
class Credits with _$Credits {
  const factory Credits({
    @Default([]) List<Cast> cast,
  }) = _Credits;

  factory Credits.fromJson(Map<String, dynamic> json) => _$CreditsFromJson(json);
}

@freezed
class Cast with _$Cast {
  const factory Cast({
    required int id,
    required String name,
    required String character,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _Cast;

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
}

@freezed
class Videos with _$Videos {
  const factory Videos({
    @Default([]) List<Video> results,
  }) = _Videos;

  factory Videos.fromJson(Map<String, dynamic> json) => _$VideosFromJson(json);
}

@freezed
class Video with _$Video {
  const factory Video({
    required String id,
    required String key,
    required String name,
    required String site,
    required String type,
  }) = _Video;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}
