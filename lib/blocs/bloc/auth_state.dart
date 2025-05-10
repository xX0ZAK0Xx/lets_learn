part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

// Google Auth States
final class GoogleAuthLoadingState extends AuthState {}

final class GoogleAuthSuccessState extends AuthState {
  final User user;

  GoogleAuthSuccessState({required this.user});
}

final class GoogleAuthFailedState extends AuthState {
  final String errorMessage;

  GoogleAuthFailedState({required this.errorMessage});
}