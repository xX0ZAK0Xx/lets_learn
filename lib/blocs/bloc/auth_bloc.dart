import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {

    on<GoogleAuthEvent>((event, emit) async {
      try {
        emit(GoogleAuthLoadingState());
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          emit(GoogleAuthFailedState(errorMessage: "User not found"));
          return;
        }
        final googleAuth = await googleUser.authentication;
        final cred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(cred).then((onValue) {
          if (onValue.user != null) {
            emit(GoogleAuthSuccessState(user: onValue.user!));
          } else {
            emit(GoogleAuthFailedState(errorMessage: "Something went wrong"));
          }
        });
      } catch (e, k) {
        log("$e\n$k");
        emit(GoogleAuthFailedState(errorMessage: e.toString()));
      }
    });
  }
}
