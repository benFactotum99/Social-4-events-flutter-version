import 'package:social_4_events/model/user.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final String userCreator;
  final double locationLongitude;
  final double locationLatitude;
  final String locationName;
  final String start;
  final String timeStart;
  final String end;
  final String timeEnd;
  final int duration;
  final double price;
  final int maxNumPartecipants;
  final List<String> notification;
  final List<String> usersPartecipants;
  final String imageUrl;

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
    this.notification = const [],
    this.usersPartecipants = const [],
    this.imageUrl = "",
  });

  factory Event.fromSnapshot(String id, Map<String, dynamic> snapshot) => Event(
        id: id,
        name: snapshot['name'],
        description: snapshot['description'],
        userCreator: snapshot['user_creator'],
        locationLongitude: snapshot['location_longitude'],
        locationLatitude: snapshot['location_latitude'],
        locationName: snapshot['location_name'],
        start: snapshot['start'],
        timeStart: snapshot['time_start'],
        end: snapshot['end'],
        timeEnd: snapshot['time_end'],
        duration: snapshot['duration'],
        price: snapshot['price'],
        maxNumPartecipants: snapshot['max_num_partecipants'],
        notification: snapshot['notification'],
        usersPartecipants: snapshot['users_partecipants'],
        imageUrl: snapshot['image_url'],
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
