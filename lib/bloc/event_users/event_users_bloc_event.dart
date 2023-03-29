abstract class EventUsersBlocEvent {}

class EventUsersBlocEventFetch extends EventUsersBlocEvent {
  final List<String> ids;
  EventUsersBlocEventFetch(this.ids);
}
