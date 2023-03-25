import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_4_events/exceptions/user_exception.dart';
import 'package:social_4_events/model/user.dart' as model;
import 'package:social_4_events/repository/master_repository.dart';

class UserRepository extends MasterRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        super(firebaseAuth: firebaseAuth, firebaseFirestore: firebaseFirestore);

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
}
