import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_event.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_state.dart';
import 'package:social_4_events/repository/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationBlocEvent, AuthenticationBlocState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationBlocStateInitialized()) {
    //Implementazione dell'evento chiamato all'avvio dell'app
    //in cui si controlla se nell'app sul dispositivo c'è stato
    //un login effettuato dall'utente, e in caso affermativo si emette lo stato
    //AuthenticationBlocStateAuthenticated altrimenti
    //AuthenticationBlocStateUnauthenticated e in caso di errore si emette
    //AuthenticationBlocStateUnauthenticated
    on<AuthenticationBlocEventAppStarted>((event, emit) async {
      try {
        var flag = await userRepository.isLoggedIn();
        if (flag == true) {
          emit(AuthenticationBlocStateAuthenticated());
        } else {
          emit(AuthenticationBlocStateUnauthenticated());
        }
      } catch (error) {
        print(error);
        emit(AuthenticationBlocStateUnauthenticated());
      }
    });

    //Evento implementato per effettuare il login con conseguente messaggio personalizzato in caso di errori
    //azioni non consentite svolte dall'utente
    on<AuthenticationBlocEventLogin>((event, emit) async {
      try {
        emit(AuthenticationBlocStateLoadingAuth());
        await userRepository.login(event.username, event.password);
        emit(AuthenticationBlocStateSuccessAuth());
      } catch (error) {
        String errorMessage;
        print((error as FirebaseAuthException).code);
        switch ((error as FirebaseAuthException).code) {
          case "ERROR_INVALID_EMAIL":
          case "invalid-email":
            errorMessage = "Email errata.";
            break;
          case "ERROR_WRONG_PASSWORD":
          case "wrong-password":
            errorMessage = "Password errata.";
            break;
          case "ERROR_USER_NOT_FOUND":
          case "user-not-found":
            errorMessage = "Non esiste un utente con queste credenziali.";
            break;
          case "ERROR_USER_DISABLED":
          case "user-disabled":
            errorMessage = "L'utente con questa email è stato disabilitato.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
          case "operation-not-allowed":
            errorMessage = "Eccesso di richieste, riprovare più tardi.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
          case "operation-not-allowed":
            errorMessage = "L'accesso con email e password non è abilitato";
            break;
          default:
            errorMessage = "Errore non definito.";
        }
        emit(AuthenticationBlocStateErrorAuth(errorMessage));
      }
    });

    //Implementazione del logout dell'utente
    on<AuthenticationBlocEventLogout>((event, emit) async {
      try {
        await userRepository.logout();
        emit(AuthenticationBlocStateUnauthenticated());
      } catch (error) {
        print(error);
      }
    });
  }
}
