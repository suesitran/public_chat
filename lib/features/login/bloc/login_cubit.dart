import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:public_chat/_shared/bloc/language_cubit.dart/language_cubit.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/repository/database.dart';
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

  void requestLogin(BuildContext context) async {
    GoogleSignInAccount? googleUser;
    // try {
    googleUser = await googleSignIn.signIn();
    // } on PlatformException catch (e) {
    //   emitSafely(LoginFailed(e.toString()));
    //   return null;
    // }

    if (googleUser == null) {
      emitSafely(const LoginFailed('User cancelled'));
      return null;
    }

    _authenticateToFirebase(googleUser).then(
      (userDetails) {
        if (context.mounted) {
          context.read<LanguageCubit>().setMessageLanguage(
              userDetails?.messageLanguage,
              saveToDatabase: false);
        }
      },
    );
  }

  Future<UserDetail?> _authenticateToFirebase(
      GoogleSignInAccount googleUser) async {
    UserDetail? userDetails;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final Database database = ServiceLocator.instance.get<Database>();
    // try {
    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(oAuthCredential);
    final User? user = userCredential.user;

    if (user == null) {
      emitSafely(const LoginFailed('Unable to get user credential'));
    } else {
      userDetails = (await database.getUser(user.uid)).data();

      userDetails ??= database.saveUser(user);

      emitSafely(LoginSuccess(user.displayName ?? 'Unknown display name'));
    }
    // } on FirebaseAuthException catch (e) {
    //   emitSafely(LoginFailed(e.toString()));
    // } catch (e) {
    //   emitSafely(LoginFailed(e.toString()));
    // }

    return userDetails;
  }

  @override
  Future<void> close() {
    userSubscription.cancel();
    return super.close();
  }
}
