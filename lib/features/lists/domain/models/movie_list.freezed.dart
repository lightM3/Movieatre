// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MovieList _$MovieListFromJson(Map<String, dynamic> json) {
  return _MovieList.fromJson(json);
}

/// @nodoc
mixin _$MovieList {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'list_type')
  String get listType => throw _privateConstructorUsedError;
  String get visibility => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Ekstra alan: UI'da o listede kaç film olduğunu veya filmlerin listesini göstermek için kullanılabilir
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<int> get movieIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MovieListCopyWith<MovieList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieListCopyWith<$Res> {
  factory $MovieListCopyWith(MovieList value, $Res Function(MovieList) then) =
      _$MovieListCopyWithImpl<$Res, MovieList>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      @JsonKey(name: 'list_type') String listType,
      String visibility,
      String? description,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<int> movieIds});
}

/// @nodoc
class _$MovieListCopyWithImpl<$Res, $Val extends MovieList>
    implements $MovieListCopyWith<$Res> {
  _$MovieListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? listType = null,
    Object? visibility = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? movieIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      listType: null == listType
          ? _value.listType
          : listType // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      movieIds: null == movieIds
          ? _value.movieIds
          : movieIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MovieListImplCopyWith<$Res>
    implements $MovieListCopyWith<$Res> {
  factory _$$MovieListImplCopyWith(
          _$MovieListImpl value, $Res Function(_$MovieListImpl) then) =
      __$$MovieListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      @JsonKey(name: 'list_type') String listType,
      String visibility,
      String? description,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<int> movieIds});
}

/// @nodoc
class __$$MovieListImplCopyWithImpl<$Res>
    extends _$MovieListCopyWithImpl<$Res, _$MovieListImpl>
    implements _$$MovieListImplCopyWith<$Res> {
  __$$MovieListImplCopyWithImpl(
      _$MovieListImpl _value, $Res Function(_$MovieListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? listType = null,
    Object? visibility = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? movieIds = null,
  }) {
    return _then(_$MovieListImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      listType: null == listType
          ? _value.listType
          : listType // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      movieIds: null == movieIds
          ? _value._movieIds
          : movieIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MovieListImpl implements _MovieList {
  const _$MovieListImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.title,
      @JsonKey(name: 'list_type') required this.listType,
      required this.visibility,
      this.description,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<int> movieIds = const []})
      : _movieIds = movieIds;

  factory _$MovieListImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovieListImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String title;
  @override
  @JsonKey(name: 'list_type')
  final String listType;
  @override
  final String visibility;
  @override
  final String? description;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
// Ekstra alan: UI'da o listede kaç film olduğunu veya filmlerin listesini göstermek için kullanılabilir
  final List<int> _movieIds;
// Ekstra alan: UI'da o listede kaç film olduğunu veya filmlerin listesini göstermek için kullanılabilir
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<int> get movieIds {
    if (_movieIds is EqualUnmodifiableListView) return _movieIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_movieIds);
  }

  @override
  String toString() {
    return 'MovieList(id: $id, userId: $userId, title: $title, listType: $listType, visibility: $visibility, description: $description, createdAt: $createdAt, movieIds: $movieIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieListImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.listType, listType) ||
                other.listType == listType) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._movieIds, _movieIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      listType,
      visibility,
      description,
      createdAt,
      const DeepCollectionEquality().hash(_movieIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieListImplCopyWith<_$MovieListImpl> get copyWith =>
      __$$MovieListImplCopyWithImpl<_$MovieListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovieListImplToJson(
      this,
    );
  }
}

abstract class _MovieList implements MovieList {
  const factory _MovieList(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String title,
      @JsonKey(name: 'list_type') required final String listType,
      required final String visibility,
      final String? description,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<int> movieIds}) = _$MovieListImpl;

  factory _MovieList.fromJson(Map<String, dynamic> json) =
      _$MovieListImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get title;
  @override
  @JsonKey(name: 'list_type')
  String get listType;
  @override
  String get visibility;
  @override
  String? get description;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override // Ekstra alan: UI'da o listede kaç film olduğunu veya filmlerin listesini göstermek için kullanılabilir
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<int> get movieIds;
  @override
  @JsonKey(ignore: true)
  _$$MovieListImplCopyWith<_$MovieListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
