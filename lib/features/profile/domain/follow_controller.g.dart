// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followControllerHash() => r'570c7841f166803c2c70bca3cbb0477772f4be89';

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

abstract class _$FollowController
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String targetUserId;

  FutureOr<bool> build(
    String targetUserId,
  );
}

/// See also [FollowController].
@ProviderFor(FollowController)
const followControllerProvider = FollowControllerFamily();

/// See also [FollowController].
class FollowControllerFamily extends Family<AsyncValue<bool>> {
  /// See also [FollowController].
  const FollowControllerFamily();

  /// See also [FollowController].
  FollowControllerProvider call(
    String targetUserId,
  ) {
    return FollowControllerProvider(
      targetUserId,
    );
  }

  @override
  FollowControllerProvider getProviderOverride(
    covariant FollowControllerProvider provider,
  ) {
    return call(
      provider.targetUserId,
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
  String? get name => r'followControllerProvider';
}

/// See also [FollowController].
class FollowControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FollowController, bool> {
  /// See also [FollowController].
  FollowControllerProvider(
    String targetUserId,
  ) : this._internal(
          () => FollowController()..targetUserId = targetUserId,
          from: followControllerProvider,
          name: r'followControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$followControllerHash,
          dependencies: FollowControllerFamily._dependencies,
          allTransitiveDependencies:
              FollowControllerFamily._allTransitiveDependencies,
          targetUserId: targetUserId,
        );

  FollowControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.targetUserId,
  }) : super.internal();

  final String targetUserId;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant FollowController notifier,
  ) {
    return notifier.build(
      targetUserId,
    );
  }

  @override
  Override overrideWith(FollowController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FollowControllerProvider._internal(
        () => create()..targetUserId = targetUserId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        targetUserId: targetUserId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FollowController, bool>
      createElement() {
    return _FollowControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowControllerProvider &&
        other.targetUserId == targetUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, targetUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FollowControllerRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `targetUserId` of this provider.
  String get targetUserId;
}

class _FollowControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FollowController, bool>
    with FollowControllerRef {
  _FollowControllerProviderElement(super.provider);

  @override
  String get targetUserId => (origin as FollowControllerProvider).targetUserId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
