import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/user/user_bloc_event.dart';
import 'package:social_4_events/bloc/user/user_bloc_state.dart';
import 'package:social_4_events/bloc/user_generic/user_generic_bloc_event.dart';
import 'package:social_4_events/bloc/user_generic/user_generic_bloc_state.dart';
import 'package:social_4_events/repository/event_repository.dart';
import 'package:social_4_events/repository/user_repository.dart';

class UserGenericBloc extends Bloc<UserGenericBlocEvent, UserGenericBlocState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;

  UserGenericBloc({required this.eventRepository, required this.userRepository})
      : super(UserGenericBlocStateLoading()) {
    on<UserGenericBlocEventFetchUserById>(
      (event, emit) async {
        try {
          emit(UserGenericBlocStateLoading());

          var user = await userRepository.getUserById(event.userId);
          if (user == null) {
            emit(
              UserGenericBlocStateError("Utente non trovato"),
            );
          } else {
            var eventsCreated =
                await eventRepository.getEventsByIds(user.eventsCreated);
            var eventsPartecipated =
                await eventRepository.getEventsByIds(user.eventsParticipated);
            emit(
              UserGenericBlocStateLoaded(
                user,
                eventsCreated,
                eventsPartecipated,
              ),
            );
          }
        } catch (error) {
          print(error);
          emit(
            UserGenericBlocStateError("Errore nel caricamento dell'utente"),
          );
        }
      },
    );
  }
}
