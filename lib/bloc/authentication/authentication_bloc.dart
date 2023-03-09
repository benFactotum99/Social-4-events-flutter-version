import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_event.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_state.dart';
import 'package:social_4_events/repository/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationBlocEvent, AuthenticationBlocState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationBlocStateInitialized()) {
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

    on<AuthenticationBlocEventLogin>((event, emit) async {
      try {
        await userRepository.login(event.username, event.password);
        emit(AuthenticationBlocStateSuccessAuth());
      } catch (error) {
        print(error);
        emit(AuthenticationBlocStateErrorAuth());
      }
    });

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
