import 'package:social_4_events/model/event.dart';

abstract class UserBlocEvent {}

class UserBlocEventUserLoggedFetch extends UserBlocEvent {
  final String userId;
  UserBlocEventUserLoggedFetch(this.userId);
}
