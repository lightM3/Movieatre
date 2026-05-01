// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      tmdbMovieId: (json['tmdb_movie_id'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      content: json['content'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      profiles: json['profiles'] == null
          ? null
          : Profile.fromJson(json['profiles'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'tmdb_movie_id': instance.tmdbMovieId,
      'rating': instance.rating,
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
      'profiles': instance.profiles,
    };
