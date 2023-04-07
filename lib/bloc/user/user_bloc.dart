import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/user/user_bloc_event.dart';
import 'package:social_4_events/bloc/user/user_bloc_state.dart';
import 'package:social_4_events/repository/event_repository.dart';
import 'package:social_4_events/repository/user_repository.dart';

class UserBloc extends Bloc<UserBlocEvent, UserBlocState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;

  UserBloc({required this.eventRepository, required this.userRepository})
      : super(UserBlocStateUserLoggedLoading()) {
    //Implementazione del fetch degli user con gli stati loading e loaded
    on<UserBlocEventFetch>(
      (event, emit) async {
        try {
          emit(UserBlocStateLoading());
          var users = await userRepository.getUsers();
          emit(UserBlocStateLoaded(users));
        } catch (error) {
          print(error);
          emit(UserBlocStateError());
        }
      },
    );

    //Metodo per il recupero dell'utente loggato e dei suoi eventi, sia creati che partecipati
    on<UserBlocEventUserLoggedFetch>(
      (event, emit) async {
        try {
          emit(UserBlocStateUserLoggedLoading());

          var user = await userRepository.getUserLogged();
          var eventsCreated =
              await eventRepository.getEventsByIds(user.eventsCreated);
          var eventsPartecipated =
              await eventRepository.getEventsByIds(user.eventsParticipated);
          emit(
            UserBlocStateUserLoggedLoaded(
              user,
              eventsCreated,
              eventsPartecipated,
            ),
          );
        } catch (error) {
          print(error);
          emit(
            UserBlocStateUserLoggedError(
                "Errore nel caricamento dell'utente loggato"),
          );
        }
      },
    );
  }
}
