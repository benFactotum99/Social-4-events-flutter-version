import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/event/event_bloc_event.dart';
import 'package:social_4_events/bloc/event/event_bloc_state.dart';
import 'package:social_4_events/repository/event_repository.dart';

class EventBloc extends Bloc<EventBlocEvent, EventBlocState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository}) : super(EventBlocStateLoading()) {
    on<EventBlocEventFetch>(
      (event, emit) async {
        try {
          //emit(IngredientBlocStateLoading());
          //var ingredients = await ingredientRepository.fetchIngredients();
          //emit(IngredientBlocStateLoaded(ingredients));
        } catch (error) {
          print(error);
          emit(EventBlocStateError());
        }
      },
    );

    on<EventBlocEventCreate>(
      (event, emit) async {
        try {
          emit(EventBlocStateCreating());
          await eventRepository.createEvent(event.event);
          emit(EventBlocStateCreated());
        } catch (error) {
          print(error);
          emit(EventBlocStateError());
        }
      },
    );

    on<EventBlocEventEdit>(
      (event, emit) async {
        try {
          //await ingredientRepository.editIngredient(event.ingredient);
          emit(EventBlocStateEdited());
        } catch (error) {
          emit(EventBlocStateError());
        }
      },
    );
  }
}
