import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/event/event_bloc_event.dart';
import 'package:social_4_events/bloc/event/event_bloc_state.dart';
import 'package:social_4_events/bloc/event_users/event_users_bloc_event.dart';
import 'package:social_4_events/bloc/event_users/event_users_bloc_state.dart';
import 'package:social_4_events/model/user.dart';
import 'package:social_4_events/repository/event_repository.dart';
import 'package:social_4_events/repository/user_repository.dart';

class EventUsersBloc extends Bloc<EventUsersBlocEvent, EventUsersBlocState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;

  EventUsersBloc({
    required this.eventRepository,
    required this.userRepository,
  }) : super(EventUsersBlocStateLoading()) {
    on<EventUsersBlocEventFetch>(
      (event, emit) async {
        try {
          emit(EventUsersBlocStateLoading());
          List<User> users = List.empty(growable: true);
          if (event.ids.isNotEmpty) {
            users = await userRepository.getUsersByIds(event.ids);
          }
          emit(EventUsersBlocStateLoaded(users));
        } catch (error) {
          print(error);
          emit(EventUsersBlocStateError(
              "Errore nel caricamento degli utenti dell'evento"));
        }
      },
    );
  }
}
