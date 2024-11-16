import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:public_chat/constants/app_texts.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/repository/preferences_manager.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

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

      // Use the language set during the previous login, default is English
      final String messLoginFailed = await PreferencesManager.instance
              .getAppText(AppTexts.unableGetUser) ??
          AppTexts.unableGetUser;

      if (user == null) {
        emitSafely(LoginFailed(messLoginFailed));
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

  @override
  Future<void> close() {
    userSubscription.cancel();
    return super.close();
  }
}
