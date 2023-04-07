import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_4_events/helpers/generic_functions_helpers/generic_functions.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/model/user.dart' as model;

abstract class MasterRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;
  MasterRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseStorage firebaseStorage,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseStorage = firebaseStorage,
        _firebaseFirestore = firebaseFirestore;

  //Metodo utile per ottenere l'oggetto User con i dati dell'utente loggato
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

  //GetAll di tutti gli eventi della base di dati che hanno una data ora di fine
  //maggiore o uguale a quella attuale
  Future<List<Event>> getEvents() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('events');

    QuerySnapshot querySnapshot = await collectionReference.get();

    List<Event> events = [];
    querySnapshot.docs.forEach((documentSnapshot) {
      Event event = Event.fromSnapshot(
          documentSnapshot.id, documentSnapshot.data() as Map<String, dynamic>);

      String dateTimeStrEndEvent = "${event.end} ${event.timeEnd}";
      if (!compareDateFirstEqualNow(dateTimeStrEndEvent)) {
        events.add(event);
      }
    });

    return events;
  }

  //GetAll degli utenti del database
  Future<List<model.User>> getUsers() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot querySnapshot = await collectionReference.get();

    List<model.User> users = [];
    querySnapshot.docs.forEach((documentSnapshot) {
      model.User customObject = model.User.fromSnapshot(
          documentSnapshot.id, documentSnapshot.data() as Map<String, dynamic>);
      users.add(customObject);
    });

    return users;
  }

  //Batch con cui vengono aggiornati due campi in contemporanea come se ciò avvenisse
  //da un unica chiamata atomica di un documento events e un documento users
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

  //Metodo per caricare un file immagine dalla galleria al Firebase Storage
  Future<String> setImageToStorage(
      File file, String forldeName, String nameId) async {
    //var extension = p.extension(file.path);
    /*Reference ref =
        _firebaseStorage.ref().child("$forldeName/$nameId$extension");
    */
    Reference ref = _firebaseStorage.ref().child("$forldeName/$nameId");

    UploadTask uploadTask = ref.putFile(
      file,
      /*SettableMetadata(
        contentType: "image/jpeg",
      ),*/
    );
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
