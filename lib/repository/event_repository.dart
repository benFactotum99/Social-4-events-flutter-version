import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_4_events/exceptions/user_exception.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/model/user.dart' as model;
import 'package:social_4_events/repository/master_repository.dart';

class EventRepository extends MasterRepository {
  late final FirebaseAuth _firebaseAuth;
  late final FirebaseStorage _firebaseStorage;
  late final FirebaseFirestore _firebaseFirestore;

  EventRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseStorage firebaseStorage,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseStorage = firebaseStorage,
        _firebaseFirestore = firebaseFirestore,
        super(
            firebaseAuth: firebaseAuth,
            firebaseStorage: firebaseStorage,
            firebaseFirestore: firebaseFirestore);

  //Metodo di creazione dell'evento, incui oltre ad aggiungerlo come evento
  //Aggiungo anche la sua immagine sullo storage recuperandone l'url
  Future<void> createEvent(File image, Event event) async {
    var eventRef = await _firebaseFirestore.collection('events').doc();
    var user = await this.getUserLogged();
    var userRef = await _firebaseFirestore.collection('users').doc(user.id);
    user.eventsCreated.add(eventRef.id);
    user.numEventsCreated = user.eventsCreated.length;

    var urlImage = await this.setImageToStorage(image, "events", eventRef.id);
    event.imageUrl = urlImage;

    WriteBatch batch = _firebaseFirestore.batch();
    batch.set(eventRef, event.toSnapshot());
    batch.update(userRef, user.toSnapshot());
    await batch.commit();
  }

  //Metodo dove aggiungo la partecipazione di un utente ad un evento
  Future<void> addPartecipationEvent(Event event) async {
    var user = await this.getUserLogged();
    user.eventsParticipated.add(event.id);
    event.usersPartecipants.add(user.id);
    await super.BatchUpdate(event, user);
  }

  //Metodo per la rimozione della partecipazione di un utente ad un evento
  Future<void> removePartecipationEvent(Event event) async {
    var user = await this.getUserLogged();
    user.eventsParticipated.remove(event.id);
    event.usersPartecipants.remove(user.id);
    await super.BatchUpdate(event, user);
  }

  //Metodo che dato un array di stringhe contenente gli id di vari eventi
  //Ottengo gli oggetti ad essi corrispondenti
  Future<List<Event>> getEventsByIds(List<String> ids) async {
    List<Event> events = List.empty(growable: true);
    for (String id in ids) {
      var event = await this.getEventById(id);
      if (event != null) events.add(event);
    }
    return events;
  }

  //Metodo per ottenere un evento conoscendone l'id
  Future<Event?> getEventById(String id) async {
    DocumentSnapshot documentSnapshot =
        await _firebaseFirestore.collection('events').doc(id).get();

    if (documentSnapshot.exists) {
      var eventMap = documentSnapshot.data() as Map<String, dynamic>;
      var event = Event.fromSnapshot(id, eventMap);
      return event;
    } else {
      return null;
    }
  }
}
