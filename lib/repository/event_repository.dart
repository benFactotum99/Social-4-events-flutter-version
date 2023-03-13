import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_4_events/exceptions/user_exception.dart';

class EventRepository {
  late final FirebaseAuth _firebaseAuth;
  late final FirebaseStorage _firebaseStorage;

  EventRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseStorage firebaseStorage,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseStorage = firebaseStorage;
}
