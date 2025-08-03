part of 'splash_view_model.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial (never started) state
class SplashInitial extends SplashState {}

/// While the 2-second delay is in flight
class SplashLoading extends SplashState {}

/// We found a token — go to Home
class SplashAuthenticated extends SplashState {}

/// No token — go to Login
class SplashUnauthenticated extends SplashState {}
