// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      topFourMovies: (json['top_four_movies'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'created_at': instance.createdAt?.toIso8601String(),
      'top_four_movies': instance.topFourMovies,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
    };
