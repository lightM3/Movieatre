// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$movieReviewsControllerHash() =>
    r'c2a369cda9c703653c8272c364b8c0f6e4c18a41';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MovieReviewsController
    extends BuildlessAutoDisposeAsyncNotifier<List<Review>> {
  late final int movieId;

  FutureOr<List<Review>> build(
    int movieId,
  );
}

/// See also [MovieReviewsController].
@ProviderFor(MovieReviewsController)
const movieReviewsControllerProvider = MovieReviewsControllerFamily();

/// See also [MovieReviewsController].
class MovieReviewsControllerFamily extends Family<AsyncValue<List<Review>>> {
  /// See also [MovieReviewsController].
  const MovieReviewsControllerFamily();

  /// See also [MovieReviewsController].
  MovieReviewsControllerProvider call(
    int movieId,
  ) {
    return MovieReviewsControllerProvider(
      movieId,
    );
  }

  @override
  MovieReviewsControllerProvider getProviderOverride(
    covariant MovieReviewsControllerProvider provider,
  ) {
    return call(
      provider.movieId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'movieReviewsControllerProvider';
}

/// See also [MovieReviewsController].
class MovieReviewsControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MovieReviewsController,
        List<Review>> {
  /// See also [MovieReviewsController].
  MovieReviewsControllerProvider(
    int movieId,
  ) : this._internal(
          () => MovieReviewsController()..movieId = movieId,
          from: movieReviewsControllerProvider,
          name: r'movieReviewsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$movieReviewsControllerHash,
          dependencies: MovieReviewsControllerFamily._dependencies,
          allTransitiveDependencies:
              MovieReviewsControllerFamily._allTransitiveDependencies,
          movieId: movieId,
        );

  MovieReviewsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.movieId,
  }) : super.internal();

  final int movieId;

  @override
  FutureOr<List<Review>> runNotifierBuild(
    covariant MovieReviewsController notifier,
  ) {
    return notifier.build(
      movieId,
    );
  }

  @override
  Override overrideWith(MovieReviewsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MovieReviewsControllerProvider._internal(
        () => create()..movieId = movieId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        movieId: movieId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MovieReviewsController, List<Review>>
      createElement() {
    return _MovieReviewsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieReviewsControllerProvider && other.movieId == movieId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movieId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MovieReviewsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<Review>> {
  /// The parameter `movieId` of this provider.
  int get movieId;
}

class _MovieReviewsControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MovieReviewsController,
        List<Review>> with MovieReviewsControllerRef {
  _MovieReviewsControllerProviderElement(super.provider);

  @override
  int get movieId => (origin as MovieReviewsControllerProvider).movieId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
