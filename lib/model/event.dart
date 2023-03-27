import 'package:social_4_events/model/user.dart';

class Event {
  String id;
  String name;
  String description;
  String userCreator;
  double locationLongitude;
  double locationLatitude;
  String locationName;
  String start;
  String timeStart;
  String end;
  String timeEnd;
  int duration;
  double price;
  int maxNumPartecipants;
  String notification;
  List<String> usersPartecipants;
  String imageUrl;

  Event({
    this.id = "",
    required this.name,
    required this.description,
    required this.userCreator,
    required this.locationLongitude,
    required this.locationLatitude,
    required this.locationName,
    required this.start,
    required this.timeStart,
    required this.end,
    required this.timeEnd,
    this.duration = 0,
    required this.price,
    required this.maxNumPartecipants,
    this.notification = "",
    this.usersPartecipants = const [],
    this.imageUrl = "",
  });

  factory Event.fromSnapshot(String id, Map<String, dynamic> snapshot) => Event(
        id: id,
        name: snapshot['name'] ?? "",
        description: snapshot['description'] ?? "",
        userCreator: snapshot['user_creator'] ?? "",
        locationLongitude: snapshot['location_longitude'] ?? 0.0,
        locationLatitude: snapshot['location_latitude'] ?? 0.0,
        locationName: snapshot['location_name'] ?? "",
        start: snapshot['start'] ?? "",
        timeStart: snapshot['time_start'] ?? "",
        end: snapshot['end'] ?? "",
        timeEnd: snapshot['time_end'] ?? "",
        duration: snapshot['duration'] ?? 0,
        price: snapshot['price'] ?? 0.0,
        maxNumPartecipants: snapshot['max_num_partecipants'] ?? 0,
        notification: snapshot['notification'] ?? "",
        usersPartecipants:
            (snapshot['users_partecipants'] ?? <dynamic>[]).cast<String>(),
        imageUrl: snapshot['image_url'] ?? "",
      );

  Map<String, dynamic> toSnapshot() => {
        "name": name,
        "description": description,
        "user_creator": userCreator,
        "location_longitude": locationLongitude,
        "location_latitude": locationLatitude,
        "location_name": locationName,
        "start": start,
        "time_start": timeStart,
        "end": end,
        "time_end": timeEnd,
        "duration": duration,
        "price": price,
        "max_num_partecipants": maxNumPartecipants,
        "notification": notification,
        "users_partecipants": usersPartecipants,
        "image_url": imageUrl,
      };
}
