import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc.dart';
import 'package:social_4_events/repository/user_repository.dart';
import 'package:social_4_events/view/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    App(
      userRepository: UserRepository(
        firebaseAuth: FirebaseAuth.instance,
      ),
    ),
  );
}
