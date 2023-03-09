abstract class AuthenticationBlocEvent {}

class AuthenticationBlocEventAppStarted extends AuthenticationBlocEvent {}

class AuthenticationBlocEventLogin extends AuthenticationBlocEvent {
  final String username;
  final String password;
  AuthenticationBlocEventLogin(this.username, this.password);
}

class AuthenticationBlocEventLogout extends AuthenticationBlocEvent {}
