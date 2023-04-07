abstract class AuthenticationBlocEvent {}

//Evento bloc che viene emesso dalla view all'avvio dell'app
class AuthenticationBlocEventAppStarted extends AuthenticationBlocEvent {}

//Evento bloc che viene emesso al login
class AuthenticationBlocEventLogin extends AuthenticationBlocEvent {
  final String username;
  final String password;
  AuthenticationBlocEventLogin(this.username, this.password);
}

//Evento bloc emesso al logout
class AuthenticationBlocEventLogout extends AuthenticationBlocEvent {}
