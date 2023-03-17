class User {
  final String id;
  final String username;
  final String password;
  final String email;
  final String name;
  final String surname;
  final String city;
  final String address;
  final int postalCode;
  final String district;
  final String nation;
  final String birthday;
  final String gender;
  final int numEventsCreated;
  final List<String> eventsCreated;
  final List<String> eventsParticipated;
  final List<String> notifications;
  final String imageUrl;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.name,
    required this.surname,
    required this.city,
    required this.address,
    required this.postalCode,
    required this.district,
    required this.nation,
    required this.birthday,
    required this.gender,
    required this.numEventsCreated,
    required this.eventsCreated,
    required this.eventsParticipated,
    required this.notifications,
    required this.imageUrl,
  });

  factory User.fromSnapshot(String id, Map<String, dynamic> snapshot) => User(
        id: id,
        username: snapshot['username'] ?? "",
        password: snapshot['password'] ?? "",
        email: snapshot['email'] ?? "",
        name: snapshot['name'] ?? "",
        surname: snapshot['surname'] ?? "",
        city: snapshot['city'] ?? "",
        address: snapshot['address'] ?? "",
        postalCode: snapshot['postal_code'] ?? 0,
        district: snapshot['district'] ?? "",
        nation: snapshot['nation'] ?? "",
        birthday: snapshot['birthday'] ?? "",
        gender: snapshot['gender'] ?? "",
        numEventsCreated: snapshot['num_events_created'] ?? 0,
        eventsCreated:
            (snapshot['events_created'] ?? <dynamic>[]).cast<String>(),
        eventsParticipated:
            (snapshot['events_participated'] ?? <dynamic>[]).cast<String>(),
        notifications:
            (snapshot['notifications'] ?? <dynamic>[]).cast<String>(),
        imageUrl: snapshot['image_url'] ?? "",
      );

  Map<String, dynamic> toSnapshot() => {
        "username": username,
        "password": password,
        "email": email,
        "name": name,
        "surname": surname,
        "city": city,
        "address": address,
        "postal_code": postalCode,
        "district": district,
        "nation": nation,
        "birthday": birthday,
        "gender": gender,
        "num_events_created": numEventsCreated,
        "events_created": eventsCreated,
        "notifications": notifications,
        "image_url": imageUrl,
      };
}
