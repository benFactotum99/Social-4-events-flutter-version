import 'package:social_4_events/model/event.dart';

abstract class EventBlocState {}

class EventBlocStateInit extends EventBlocState {}

class EventBlocStateLoading extends EventBlocState {}

class EventBlocStateLoaded extends EventBlocState {
  final List<Event> events;
  EventBlocStateLoaded(this.events);
}

class EventBlocStateCreating extends EventBlocState {}

class EventBlocStateCreated extends EventBlocState {}

class EventBlocStateEdited extends EventBlocState {}

class EventBlocStateError extends EventBlocState {}

class EventBlocStatePartecipationAdding extends EventBlocState {}

class EventBlocStatePartecipationAdded extends EventBlocState {}

class EventBlocStatePartecipationRemoving extends EventBlocState {}

class EventBlocStatePartecipationRemoved extends EventBlocState {}

class EventBlocStatePartecipationError extends EventBlocState {
  final String errorMessage;
  EventBlocStatePartecipationError(this.errorMessage);
}
