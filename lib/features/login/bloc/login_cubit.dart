import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/bloc_extensions.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial()) {
    userSubscription = googleSignIn.onCurrentUserChanged.listen(
      (user) {
        if (user != null) {
          _authenticateToFirebase(user);
        }
      },
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  late final StreamSubscription userSubscription;

  void requestLogin() async {
    emitSafely(LoginLoading());
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await googleSignIn.signIn();
    } on PlatformException catch (e) {
      emitSafely(LoginFailed(e.toString()));
      return null;
    }

    if (googleUser == null) {
      emitSafely(const LoginFailed('User cancelled'));
      return null;
    }

    await _authenticateToFirebase(googleUser);
  }

  Future<void> _authenticateToFirebase(GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final Database database = ServiceLocator.instance.get<Database>();
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(oAuthCredential);
      final User? user = userCredential.user;

      if (user == null) {
        emitSafely(const LoginFailed('Unable to get user credential'));
        return;
      }

      database.saveUser(user);
      emitSafely(LoginSuccess(user.displayName ?? 'Unknown display name'));
    } on FirebaseAuthException catch (e) {
      emitSafely(LoginFailed(e.toString()));
      return;
    } catch (e) {
      emitSafely(LoginFailed(e.toString()));
      return;
    }
  }

  Future<void> requestLogout() async {
    try {
      emitSafely(LogoutLoading());
      await FirebaseAuth.instance
          .signOut()
          .then((value) => emitSafely(LogoutSuccess()));
    } on PlatformException catch (e) {
      emitSafely(LoginFailed(e.toString()));
    }
  }

  bool checkCountryCodeLocalExisted() {
    return (ServiceLocator.instance
                .get<SharedPreferences>()
                .get(Constants.prefCurrentCountryCode)
                ?.toString() ??
            '')
        .isNotEmpty;
  }

  @override
  Future<void> close() {
    userSubscription.cancel();
    return super.close();
  }
}
