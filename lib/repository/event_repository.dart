import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_4_events/exceptions/user_exception.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/repository/master_repository.dart';
import 'package:social_4_events/repository/user_repository.dart';

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
        super(firebaseAuth: firebaseAuth, firebaseFirestore: firebaseFirestore);

  Future<void> createEvent(Event event) async {
    DocumentReference docRef =
        await _firebaseFirestore.collection('events').add(event.toSnapshot());
    var user = await this.getUserLoggedById();
    user.eventsCreated.add(docRef.id);
    await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toSnapshot());
  }
}
