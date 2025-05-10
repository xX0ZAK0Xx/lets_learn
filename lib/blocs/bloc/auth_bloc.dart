import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<PhoneNumberAuthEvent>((event, emit) async {
      try {
        emit(PhoneNumberAuthLoadingState());

        final completer = Completer<void>();

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (!completer.isCompleted) completer.complete();
          },
          verificationFailed: (FirebaseAuthException e) {
            log(e.toString());
            if (!completer.isCompleted) {
              completer.complete();
              emit(
                PhoneNumberAuthFailedState(
                  errorMessage: e.message ?? "Authentication failed",
                ),
              );
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            if (!completer.isCompleted) {
              completer.complete();
              emit(
                PhoneNumberAuthSuccessState(
                  verificationId: verificationId,
                  phonNumber: event.phoneNumber,
                ),
              );
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log("Time out");
            if (!completer.isCompleted) {
              completer.complete();
              emit(
                PhoneNumberAuthFailedState(
                  errorMessage: "Timeout: $verificationId",
                ),
              );
            }
          },
        );

        await completer.future;
      } catch (e, k) {
        log("$e\n$k");
        emit(PhoneNumberAuthFailedState(errorMessage: e.toString()));
      }
    });

    on<VerifyOTPEvent>((event, emit) async {
      try {
        emit(VerifyOtpLoadingState());
        final cred = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.otp,
        );
        await FirebaseAuth.instance.signInWithCredential(cred).then((value) {
          if (value.user != null) {
            emit(VerifyOtpSuccessState());
          } else {
            emit(VerifyOtpFailedState(errorMessage: "Something went wrong"));
          }
        });
      } catch (e, k) {
        log("$e\n$k");
        emit(VerifyOtpFailedState(errorMessage: e.toString()));
      }
    });

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
