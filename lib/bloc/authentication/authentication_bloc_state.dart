abstract class AuthenticationBlocState {}

class AuthenticationBlocStateInitialized extends AuthenticationBlocState {}

class AuthenticationBlocStateUnitialized extends AuthenticationBlocState {}

class AuthenticationBlocStateAuthenticated extends AuthenticationBlocState {}

class AuthenticationBlocStateUnauthenticated extends AuthenticationBlocState {}

class AuthenticationBlocStateLoadingAuth extends AuthenticationBlocState {}

class AuthenticationBlocStateSuccessAuth extends AuthenticationBlocState {}

class AuthenticationBlocStateErrorAuth extends AuthenticationBlocState {
  String errorMessage;
  AuthenticationBlocStateErrorAuth(this.errorMessage);
}
