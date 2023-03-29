import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_4_events/exceptions/user_exception.dart';
import 'package:social_4_events/model/user.dart' as model;
import 'package:social_4_events/repository/master_repository.dart';

class UserRepository extends MasterRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({
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

  Future<void> login(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> isLoggedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUserId() async {
    var flag = await isLoggedIn();
    if (flag == true) {
      var user = _firebaseAuth.currentUser;
      return user!.uid;
    } else {
      throw UserException("Utente non loggato");
    }
  }

  Future<model.User> getUserLogged() async {
    return await super.getUserLogged();
  }

  Future<model.User?> getUserById(String userId) async {
    DocumentSnapshot documentSnapshot =
        await _firebaseFirestore.collection('users').doc(userId).get();

    if (documentSnapshot.exists) {
      var userMap = documentSnapshot.data() as Map<String, dynamic>;
      var user =
          model.User.fromSnapshot(_firebaseAuth.currentUser!.uid, userMap);
      return user;
    } else {
      return null;
    }
  }

  Future<List<model.User>> getUsersByIds(List<String> ids) async {
    List<model.User> users = List.empty(growable: true);
    for (String id in ids) {
      var user = await this.getUserById(id);
      if (user != null) users.add(user);
    }
    return users;
  }
}
