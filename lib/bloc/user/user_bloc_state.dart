import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/model/user.dart';

abstract class UserBlocState {}

class UserBlocStateUserLoggedLoaded extends UserBlocState {
  final User user;
  final List<Event> eventsCreated;
  final List<Event> eventsPartecipated;
  UserBlocStateUserLoggedLoaded(
    this.user,
    this.eventsCreated,
    this.eventsPartecipated,
  );
}

class UserBlocStateUserLoggedLoading extends UserBlocState {}

class UserBlocStateUserLoggedError extends UserBlocState {
  final String errorMessage;
  UserBlocStateUserLoggedError(this.errorMessage);
}
