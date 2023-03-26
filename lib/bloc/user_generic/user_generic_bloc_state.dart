import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/model/user.dart';

abstract class UserGenericBlocState {}

class UserGenericBlocStateLoaded extends UserGenericBlocState {
  final User user;
  final List<Event> eventsCreated;
  final List<Event> eventsPartecipated;
  UserGenericBlocStateLoaded(
    this.user,
    this.eventsCreated,
    this.eventsPartecipated,
  );
}

class UserGenericBlocStateLoading extends UserGenericBlocState {}

class UserGenericBlocStateError extends UserGenericBlocState {
  final String errorMessage;
  UserGenericBlocStateError(this.errorMessage);
}
