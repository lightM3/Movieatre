// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MovieListItem _$MovieListItemFromJson(Map<String, dynamic> json) {
  return _MovieListItem.fromJson(json);
}

/// @nodoc
mixin _$MovieListItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'list_id')
  String get listId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tmdb_movie_id')
  int get tmdbMovieId => throw _privateConstructorUsedError;
  @JsonKey(name: 'added_at')
  DateTime? get addedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MovieListItemCopyWith<MovieListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieListItemCopyWith<$Res> {
  factory $MovieListItemCopyWith(
          MovieListItem value, $Res Function(MovieListItem) then) =
      _$MovieListItemCopyWithImpl<$Res, MovieListItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'list_id') String listId,
      @JsonKey(name: 'tmdb_movie_id') int tmdbMovieId,
      @JsonKey(name: 'added_at') DateTime? addedAt});
}

/// @nodoc
class _$MovieListItemCopyWithImpl<$Res, $Val extends MovieListItem>
    implements $MovieListItemCopyWith<$Res> {
  _$MovieListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? tmdbMovieId = null,
    Object? addedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String,
      tmdbMovieId: null == tmdbMovieId
          ? _value.tmdbMovieId
          : tmdbMovieId // ignore: cast_nullable_to_non_nullable
              as int,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MovieListItemImplCopyWith<$Res>
    implements $MovieListItemCopyWith<$Res> {
  factory _$$MovieListItemImplCopyWith(
          _$MovieListItemImpl value, $Res Function(_$MovieListItemImpl) then) =
      __$$MovieListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'list_id') String listId,
      @JsonKey(name: 'tmdb_movie_id') int tmdbMovieId,
      @JsonKey(name: 'added_at') DateTime? addedAt});
}

/// @nodoc
class __$$MovieListItemImplCopyWithImpl<$Res>
    extends _$MovieListItemCopyWithImpl<$Res, _$MovieListItemImpl>
    implements _$$MovieListItemImplCopyWith<$Res> {
  __$$MovieListItemImplCopyWithImpl(
      _$MovieListItemImpl _value, $Res Function(_$MovieListItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? tmdbMovieId = null,
    Object? addedAt = freezed,
  }) {
    return _then(_$MovieListItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String,
      tmdbMovieId: null == tmdbMovieId
          ? _value.tmdbMovieId
          : tmdbMovieId // ignore: cast_nullable_to_non_nullable
              as int,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MovieListItemImpl implements _MovieListItem {
  const _$MovieListItemImpl(
      {required this.id,
      @JsonKey(name: 'list_id') required this.listId,
      @JsonKey(name: 'tmdb_movie_id') required this.tmdbMovieId,
      @JsonKey(name: 'added_at') this.addedAt});

  factory _$MovieListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovieListItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'list_id')
  final String listId;
  @override
  @JsonKey(name: 'tmdb_movie_id')
  final int tmdbMovieId;
  @override
  @JsonKey(name: 'added_at')
  final DateTime? addedAt;

  @override
  String toString() {
    return 'MovieListItem(id: $id, listId: $listId, tmdbMovieId: $tmdbMovieId, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieListItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listId, listId) || other.listId == listId) &&
            (identical(other.tmdbMovieId, tmdbMovieId) ||
                other.tmdbMovieId == tmdbMovieId) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, listId, tmdbMovieId, addedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieListItemImplCopyWith<_$MovieListItemImpl> get copyWith =>
      __$$MovieListItemImplCopyWithImpl<_$MovieListItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovieListItemImplToJson(
      this,
    );
  }
}

abstract class _MovieListItem implements MovieListItem {
  const factory _MovieListItem(
          {required final String id,
          @JsonKey(name: 'list_id') required final String listId,
          @JsonKey(name: 'tmdb_movie_id') required final int tmdbMovieId,
          @JsonKey(name: 'added_at') final DateTime? addedAt}) =
      _$MovieListItemImpl;

  factory _MovieListItem.fromJson(Map<String, dynamic> json) =
      _$MovieListItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'list_id')
  String get listId;
  @override
  @JsonKey(name: 'tmdb_movie_id')
  int get tmdbMovieId;
  @override
  @JsonKey(name: 'added_at')
  DateTime? get addedAt;
  @override
  @JsonKey(ignore: true)
  _$$MovieListItemImplCopyWith<_$MovieListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
