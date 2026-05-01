// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieListImpl _$$MovieListImplFromJson(Map<String, dynamic> json) =>
    _$MovieListImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      listType: json['list_type'] as String,
      visibility: json['visibility'] as String,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MovieListImplToJson(_$MovieListImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'list_type': instance.listType,
      'visibility': instance.visibility,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
    };
