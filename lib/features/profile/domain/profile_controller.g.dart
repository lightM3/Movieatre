// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileControllerHash() => r'1d4027f7357f1329d9fa4a9b7b039da684f235d7';

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

abstract class _$ProfileController
    extends BuildlessAutoDisposeAsyncNotifier<ProfileState> {
  late final String? userId;

  FutureOr<ProfileState> build([
    String? userId,
  ]);
}

/// See also [ProfileController].
@ProviderFor(ProfileController)
const profileControllerProvider = ProfileControllerFamily();

/// See also [ProfileController].
class ProfileControllerFamily extends Family<AsyncValue<ProfileState>> {
  /// See also [ProfileController].
  const ProfileControllerFamily();

  /// See also [ProfileController].
  ProfileControllerProvider call([
    String? userId,
  ]) {
    return ProfileControllerProvider(
      userId,
    );
  }

  @override
  ProfileControllerProvider getProviderOverride(
    covariant ProfileControllerProvider provider,
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
  String? get name => r'profileControllerProvider';
}

/// See also [ProfileController].
class ProfileControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ProfileController, ProfileState> {
  /// See also [ProfileController].
  ProfileControllerProvider([
    String? userId,
  ]) : this._internal(
          () => ProfileController()..userId = userId,
          from: profileControllerProvider,
          name: r'profileControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileControllerHash,
          dependencies: ProfileControllerFamily._dependencies,
          allTransitiveDependencies:
              ProfileControllerFamily._allTransitiveDependencies,
          userId: userId,
        );

  ProfileControllerProvider._internal(
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
  FutureOr<ProfileState> runNotifierBuild(
    covariant ProfileController notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(ProfileController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfileControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ProfileController, ProfileState>
      createElement() {
    return _ProfileControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileControllerProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProfileControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ProfileState> {
  /// The parameter `userId` of this provider.
  String? get userId;
}

class _ProfileControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ProfileController,
        ProfileState> with ProfileControllerRef {
  _ProfileControllerProviderElement(super.provider);

  @override
  String? get userId => (origin as ProfileControllerProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
