part of 'auth_bloc.dart';

sealed class AuthEvent {}

class PhoneNumberAuthEvent extends AuthEvent {
  final String phoneNumber;

  PhoneNumberAuthEvent({required this.phoneNumber});
}

class VerifyOTPEvent extends AuthEvent {
  final String otp, verificationId;

  VerifyOTPEvent({required this.otp, required this.verificationId});
}

class GoogleAuthEvent extends AuthEvent{}