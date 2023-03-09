import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_4_events/exceptions/user_exception.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

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
}
