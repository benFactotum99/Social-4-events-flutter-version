import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/model/user.dart' as model;

abstract class MasterRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  MasterRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  Future<model.User> getUserLogged() async {
    DocumentSnapshot documentSnapshot = await _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();

    if (documentSnapshot.exists) {
      var userMap = documentSnapshot.data() as Map<String, dynamic>;
      var user =
          model.User.fromSnapshot(_firebaseAuth.currentUser!.uid, userMap);
      return user;
    } else {
      throw Exception("Utente non trovato");
    }
  }

  Future<List<Event>> getEvents() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('events');

    QuerySnapshot querySnapshot = await collectionReference.get();

    List<Event> events = [];
    querySnapshot.docs.forEach((documentSnapshot) {
      Event customObject = Event.fromSnapshot(
          documentSnapshot.id, documentSnapshot.data() as Map<String, dynamic>);
      events.add(customObject);
    });

    return events;
  }

  Future<void> BatchUpdate(Event event, model.User user) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('events');

    WriteBatch batch = _firebaseFirestore.batch();
    batch.update(usersCollection.doc(user.id),
        {"events_partecipated": user.eventsParticipated});
    batch.update(eventsCollection.doc(event.id),
        {"users_partecipants": event.usersPartecipants});

    await batch.commit();
  }
}
