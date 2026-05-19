// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listDetailControllerHash() =>
    r'560f1582e20679e1be7b9a20f533517a9a5fb7bc';

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

abstract class _$ListDetailController
    extends BuildlessAutoDisposeAsyncNotifier<List<Movie>> {
  late final String listId;

  FutureOr<List<Movie>> build(
    String listId,
  );
}

/// See also [ListDetailController].
@ProviderFor(ListDetailController)
const listDetailControllerProvider = ListDetailControllerFamily();

/// See also [ListDetailController].
class ListDetailControllerFamily extends Family<AsyncValue<List<Movie>>> {
  /// See also [ListDetailController].
  const ListDetailControllerFamily();

  /// See also [ListDetailController].
  ListDetailControllerProvider call(
    String listId,
  ) {
    return ListDetailControllerProvider(
      listId,
    );
  }

  @override
  ListDetailControllerProvider getProviderOverride(
    covariant ListDetailControllerProvider provider,
  ) {
    return call(
      provider.listId,
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
  String? get name => r'listDetailControllerProvider';
}

/// See also [ListDetailController].
class ListDetailControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ListDetailController, List<Movie>> {
  /// See also [ListDetailController].
  ListDetailControllerProvider(
    String listId,
  ) : this._internal(
          () => ListDetailController()..listId = listId,
          from: listDetailControllerProvider,
          name: r'listDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$listDetailControllerHash,
          dependencies: ListDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              ListDetailControllerFamily._allTransitiveDependencies,
          listId: listId,
        );

  ListDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.listId,
  }) : super.internal();

  final String listId;

  @override
  FutureOr<List<Movie>> runNotifierBuild(
    covariant ListDetailController notifier,
  ) {
    return notifier.build(
      listId,
    );
  }

  @override
  Override overrideWith(ListDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ListDetailControllerProvider._internal(
        () => create()..listId = listId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        listId: listId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ListDetailController, List<Movie>>
      createElement() {
    return _ListDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ListDetailControllerProvider && other.listId == listId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, listId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ListDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<Movie>> {
  /// The parameter `listId` of this provider.
  String get listId;
}

class _ListDetailControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ListDetailController,
        List<Movie>> with ListDetailControllerRef {
  _ListDetailControllerProviderElement(super.provider);

  @override
  String get listId => (origin as ListDetailControllerProvider).listId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
