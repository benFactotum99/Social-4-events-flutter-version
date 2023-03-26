import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/model/user.dart';

abstract class UserBlocState {}

class UserBlocStateLoading extends UserBlocState {}

class UserBlocStateLoaded extends UserBlocState {
  final List<User> users;
  UserBlocStateLoaded(this.users);
}

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

class UserBlocStateError extends UserBlocState {}

class UserBlocStateUserLoggedLoading extends UserBlocState {}

class UserBlocStateUserLoggedError extends UserBlocState {
  final String errorMessage;
  UserBlocStateUserLoggedError(this.errorMessage);
}
