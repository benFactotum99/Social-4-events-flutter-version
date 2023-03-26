abstract class UserGenericBlocEvent {}

class UserGenericBlocEventFetchUserById extends UserGenericBlocEvent {
  final String userId;
  UserGenericBlocEventFetchUserById(this.userId);
}
