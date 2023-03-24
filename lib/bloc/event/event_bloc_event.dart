import 'package:social_4_events/model/event.dart';

abstract class EventBlocEvent {}

class EventBlocEventFetch extends EventBlocEvent {}

class EventBlocEventCreate extends EventBlocEvent {
  final Event event;
  EventBlocEventCreate(this.event);
}

class EventBlocEventEdit extends EventBlocEvent {
  final Event event;
  EventBlocEventEdit(this.event);
}

class EventBlocEventAddPartecipation extends EventBlocEvent {
  final Event event;
  EventBlocEventAddPartecipation(this.event);
}

class EventBlocEventRemovePartecipation extends EventBlocEvent {
  final Event event;
  EventBlocEventRemovePartecipation(this.event);
}
