// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listControllerHash() => r'd0c4d4d2f5bca4fd8c8605c692179025ac573382';

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

abstract class _$ListController
    extends BuildlessAutoDisposeAsyncNotifier<List<MovieList>> {
  late final String? userId;

  FutureOr<List<MovieList>> build([
    String? userId,
  ]);
}

/// See also [ListController].
@ProviderFor(ListController)
const listControllerProvider = ListControllerFamily();

/// See also [ListController].
class ListControllerFamily extends Family<AsyncValue<List<MovieList>>> {
  /// See also [ListController].
  const ListControllerFamily();

  /// See also [ListController].
  ListControllerProvider call([
    String? userId,
  ]) {
    return ListControllerProvider(
      userId,
    );
  }

  @override
  ListControllerProvider getProviderOverride(
    covariant ListControllerProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'listControllerProvider';
}

/// See also [ListController].
class ListControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ListController, List<MovieList>> {
  /// See also [ListController].
  ListControllerProvider([
    String? userId,
  ]) : this._internal(
          () => ListController()..userId = userId,
          from: listControllerProvider,
          name: r'listControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$listControllerHash,
          dependencies: ListControllerFamily._dependencies,
          allTransitiveDependencies:
              ListControllerFamily._allTransitiveDependencies,
          userId: userId,
        );

  ListControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String? userId;

  @override
  FutureOr<List<MovieList>> runNotifierBuild(
    covariant ListController notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(ListController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ListControllerProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ListController, List<MovieList>>
      createElement() {
    return _ListControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ListControllerProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ListControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<MovieList>> {
  /// The parameter `userId` of this provider.
  String? get userId;
}

class _ListControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ListController,
        List<MovieList>> with ListControllerRef {
  _ListControllerProviderElement(super.provider);

  @override
  String? get userId => (origin as ListControllerProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
