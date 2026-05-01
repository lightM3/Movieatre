import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    String? email,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'top_four_movies') List<int>? topFourMovies,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
