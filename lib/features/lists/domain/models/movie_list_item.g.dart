// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieListItemImpl _$$MovieListItemImplFromJson(Map<String, dynamic> json) =>
    _$MovieListItemImpl(
      id: json['id'] as String,
      listId: json['list_id'] as String,
      tmdbMovieId: (json['tmdb_movie_id'] as num).toInt(),
      addedAt: json['added_at'] == null
          ? null
          : DateTime.parse(json['added_at'] as String),
    );

Map<String, dynamic> _$$MovieListItemImplToJson(_$MovieListItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'list_id': instance.listId,
      'tmdb_movie_id': instance.tmdbMovieId,
      'added_at': instance.addedAt?.toIso8601String(),
    };
