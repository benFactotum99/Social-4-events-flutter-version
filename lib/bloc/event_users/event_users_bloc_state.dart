import 'package:social_4_events/model/user.dart';

abstract class EventUsersBlocState {}

class EventUsersBlocStateLoading extends EventUsersBlocState {}

class EventUsersBlocStateLoaded extends EventUsersBlocState {
  final List<User> users;
  EventUsersBlocStateLoaded(this.users);
}

class EventUsersBlocStateError extends EventUsersBlocState {
  final String errorMessage;
  EventUsersBlocStateError(this.errorMessage);
}
