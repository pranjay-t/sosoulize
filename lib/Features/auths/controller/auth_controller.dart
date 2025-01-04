import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/repository/auth_repository.dart';
import 'package:sosoulize/models/user_models.dart';
import 'package:sosoulize/core/constants/utils.dart';

final userProvider = StateProvider<UserModels?>((ref) => null);


final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
    return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref,String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return  authController.getUserData(uid);
});


final authControllerProvider = StateNotifierProvider<AuthController,bool>(
  (ref) => AuthController(
    auth_repository: ref.watch(
      authRepositoryProvider,
    ),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    // ignore: non_constant_identifier_names
    required AuthRepository auth_repository,
    required Ref ref,
  })  : _authRepository = auth_repository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context,bool isFromLogin) async {
    state = true;
    final user = await _authRepository.signInWithGoogle(isFromLogin);
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void signInWithGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void logOut(){
    _authRepository.logOut();
  }

  Stream<UserModels> getUserData(String uid){
      return _authRepository.getUserData(uid);
    }
}
