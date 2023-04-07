import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/event/event_bloc_event.dart';
import 'package:social_4_events/bloc/event/event_bloc_state.dart';
import 'package:social_4_events/repository/event_repository.dart';

class EventBloc extends Bloc<EventBlocEvent, EventBlocState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository}) : super(EventBlocStateLoading()) {
    //Implementazione del metodo di get all dell'event bloc
    //inizialmente viene emesso lo stato di loading alla ricezione dell'evento
    //EventBlocEventFetch dalla view, si effettua il getAll su Events dal Repository
    //Successivamente si emette EventBlocStateLoaded passando la lista di eventi
    //oppure EventBlocStateError con il messaggio di testo in caso di errore
    on<EventBlocEventFetch>(
      (event, emit) async {
        try {
          emit(EventBlocStateLoading());
          var events = await eventRepository.getEvents();
          emit(EventBlocStateLoaded(events));
        } catch (error) {
          print(error);
          emit(EventBlocStateError("Errore nel caricamento degli eventi"));
        }
      },
    );

    //Implementazione del create event
    on<EventBlocEventCreate>(
      (event, emit) async {
        try {
          emit(EventBlocStateCreating());
          await eventRepository.createEvent(event.image, event.event);
          emit(EventBlocStateCreated());
        } on FirebaseException catch (error) {
          print(error);
          if (error.plugin == "firebase_storage") {
            emit(EventBlocStateImageError(
                "Errore nel caricamento dell'immagine"));
          } else {
            emit(EventBlocStateError("Errore generico"));
          }
        } catch (error) {
          print(error);
          emit(EventBlocStateError("Errore generico"));
        }
      },
    );

    //Implementazione dell'ad partecipation
    on<EventBlocEventAddPartecipation>(
      (event, emit) async {
        try {
          emit(EventBlocStatePartecipationAdding());
          await eventRepository.addPartecipationEvent(event.event);
          emit(EventBlocStatePartecipationAdded());
        } catch (error) {
          print(error);
          emit(EventBlocStatePartecipationError("Errore nella partecipazione"));
        }
      },
    );

    //Implementazione del remove partecipation
    on<EventBlocEventRemovePartecipation>(
      (event, emit) async {
        try {
          emit(EventBlocStatePartecipationRemoving());
          await eventRepository.removePartecipationEvent(event.event);
          emit(EventBlocStatePartecipationRemoved());
        } catch (error) {
          print(error);
          emit(EventBlocStatePartecipationError(
              "Errore nella rimozione della partecipazione"));
        }
      },
    );
  }
}
