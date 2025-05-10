part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

//? Phone Number Auth States
final class PhoneNumberAuthLoadingState extends AuthState {}

final class PhoneNumberAuthSuccessState extends AuthState {
  final String verificationId, phonNumber;

  PhoneNumberAuthSuccessState({required this.verificationId, required this.phonNumber});
}

final class PhoneNumberAuthFailedState extends AuthState {
  final String errorMessage;

  PhoneNumberAuthFailedState({required this.errorMessage});
}

// Verify OTP State
final class VerifyOtpLoadingState extends AuthState {}

final class VerifyOtpSuccessState extends AuthState {}

final class VerifyOtpFailedState extends AuthState {
  final String errorMessage;

  VerifyOtpFailedState({required this.errorMessage});
}

// Google Auth States
final class GoogleAuthLoadingState extends AuthState {}

class GoogleAuthSuccessState extends AuthState {
  final User user;

  GoogleAuthSuccessState({required this.user});
}

final class GoogleAuthFailedState extends AuthState {
  final String errorMessage;

  GoogleAuthFailedState({required this.errorMessage});
}