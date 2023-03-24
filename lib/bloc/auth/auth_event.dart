part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AppLogoutRequested extends AuthEvent {
  const AppLogoutRequested();
}

class _AppUserChanged extends AuthEvent {
  const _AppUserChanged(this.user);

  final User user;
}
