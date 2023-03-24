import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_event.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_state.dart';
import 'package:social_4_events/view/app.dart';
import 'package:social_4_events/view/login/login_view.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationBlocState>(
      listener: (context, state) {
        if (state is AuthenticationBlocStateUnauthenticated) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginView(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: false,
          title: Text(
            "User",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  AuthenticationBlocEventLogout(),
                );
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 35),
              imageEventSection(),
              SizedBox(height: 25),
              Text("Nome Utente", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text("Genere", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text("Nazione", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              SizedBox(
                height: 40,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Info utente'),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(
                    6,
                    (index) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 0.5,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/social4events-3a697.appspot.com/o/events%2F1K3qgTLcZ25JX7CQr9ER?alt=media&token=314fbbee-4e6e-4f14-a394-70c04c5f7430"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              /*Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(
                    9,
                    (index) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/post_$index.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  imageEventSection() => InkWell(
        onTap: () {},
        child: CircleAvatar(
          radius: 100.0,
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          child: Transform.scale(
            scale: 5,
            child: Icon(Icons.account_box_rounded),
          ),
        ),
      );
}
