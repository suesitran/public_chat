import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void requestLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await googleSignIn.signIn();
    } on PlatformException catch (e) {
      emitSafely(LoginFailed(e.toString()));
      return null;
    }

    if (googleUser == null) {
      emitSafely(LoginFailed('User cancelled'));
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(oAuthCredential);
      final User? user = userCredential.user;

      if (user == null) {
        emitSafely(LoginFailed('Unable to get user credential'));

        return null;
      }

      emitSafely(LoginSuccess(user.displayName ?? 'Unknown display name'));
    } on FirebaseAuthException catch (e) {
      emitSafely(LoginFailed(e.toString()));
      return null;
    } catch (e) {
      emitSafely(LoginFailed(e.toString()));
      return null;
    }
  }
}
