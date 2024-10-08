import 'dart:async';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// Mock authentication service to be used for testing the UI
/// Keeps an in-memory store of registered accounts so that registration and sign in flows can be tested.
class MockAuthService implements AuthService {
  MockAuthService({
    this.startupTime = const Duration(milliseconds: 250),
    this.responseTime = const Duration(seconds: 2),
  }) {
    Future<void>.delayed(responseTime!).then((_) {
      // _add(null);
    });
  }

  final Duration? startupTime;
  final Duration? responseTime;

  final Map<String, _UserData> _usersStore = <String, _UserData>{};

  UserFromFirebase? _currentUser;

  final StreamController<UserFromFirebase> _onAuthStateChangedController =
      StreamController<UserFromFirebase>();

  @override
  Stream<UserFromFirebase> get onAuthStateChanged =>
      _onAuthStateChangedController.stream;

  @override
  Future<UserFromFirebase> currentUser() async {
    await Future<void>.delayed(startupTime!);
    return _currentUser!;
  }

  @override
  Future<UserFromFirebase> createUserWithEmailAndPassword(
      String email, String password) async {
    await Future<void>.delayed(responseTime!);
    if (_usersStore.keys.contains(email)) {
      throw PlatformException(
        code: 'ERROR_EMAIL_ALREADY_IN_USE',
        message: 'The email address is already registered. Sign in instead?',
      );
    }
    final UserFromFirebase user = UserFromFirebase(
        uid: DateTime.now().millisecondsSinceEpoch.toString(), email: email);
    _usersStore[email] = _UserData(password: password, user: user);
    _add(user);
    return user;
  }

  @override
  Future<UserFromFirebase> signInWithEmailAndPassword(
      String email, String password) async {
    await Future<void>.delayed(responseTime!);
    if (!_usersStore.keys.contains(email)) {
      throw PlatformException(
        code: 'ERROR_USER_NOT_FOUND',
        message: 'The email address is not registered. Need an account?',
      );
    }
    final _UserData _userData = _usersStore[email]!;
    if (_userData.password != password) {
      throw PlatformException(
        code: 'ERROR_WRONG_PASSWORD',
        message: 'The password is incorrect. Please try again.',
      );
    }
    _add(_userData.user);
    return _userData.user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<UserFromFirebase> signInWithEmailAndLink(
      {String? email, String? link}) async {
    await Future<void>.delayed(responseTime!);
    final UserFromFirebase user =
        UserFromFirebase(uid: DateTime.now().millisecondsSinceEpoch.toString());
    _add(user);
    return user;
  }

  @override
  Future<bool> isSignInWithEmailLink(String link) async {
    return true;
  }

  @override
  Future<void> signOut() async {
    // _add(null);
  }

  void _add(UserFromFirebase user) {
    _currentUser = user;
    _onAuthStateChangedController.add(user!);
  }

  @override
  Future<UserFromFirebase> signInAnonymously() async {
    await Future<void>.delayed(responseTime!);
    final UserFromFirebase user =
        UserFromFirebase(uid: DateTime.now().millisecondsSinceEpoch.toString());
    _add(user);
    return user;
  }

  @override
  Future<UserFromFirebase> signInWithFacebook() async {
    await Future<void>.delayed(responseTime!);
    final UserFromFirebase user =
        UserFromFirebase(uid: DateTime.now().millisecondsSinceEpoch.toString());
    _add(user);
    return user;
  }

  @override
  Future<UserFromFirebase> signInWithGoogle() async {
    await Future<void>.delayed(responseTime!);
    final UserFromFirebase user =
        UserFromFirebase(uid: DateTime.now().millisecondsSinceEpoch.toString());
    _add(user);
    return user;
  }

  @override
  Future<UserFromFirebase> signInWithApple({List? scopes}) async {
    await Future<void>.delayed(responseTime!);
    final UserFromFirebase user =
        UserFromFirebase(uid: DateTime.now().millisecondsSinceEpoch.toString());
    _add(user);
    return user;
  }

  @override
  void dispose() {
    _onAuthStateChangedController.close();
  }

  @override
  Future<void> sendSignInWithEmailLink({
    String? email,
    String? url,
    bool? handleCodeInApp,
    String? iOSBundleID,
    String? androidPackageName,
    bool? androidInstallIfNotAvailable,
    String? androidMinimumVersion,
  }) {
    // TODO: implement sendSignInWithEmailLink
    throw UnimplementedError();
  }
}

class _UserData {
  _UserData({required this.password, required this.user});

  final String password;
  final UserFromFirebase user;
}
