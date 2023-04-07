abstract class AuthenticationBlocState {}

//Insieme complessivo di stati che regolano il bloc authentication
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
