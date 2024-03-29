import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/event_users/event_users_bloc.dart';
import 'package:social_4_events/bloc/event_users/event_users_bloc_event.dart';
import 'package:social_4_events/bloc/event_users/event_users_bloc_state.dart';
import 'package:social_4_events/bloc/user/user_bloc.dart';
import 'package:social_4_events/bloc/user/user_bloc_event.dart';
import 'package:social_4_events/bloc/user/user_bloc_state.dart';
import 'package:social_4_events/cubit/index_tab_cubit.dart';
import 'package:social_4_events/helpers/enums/tab_index_enum.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_users_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/search_user_view_arguments.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/model/user.dart' as model;
import 'package:social_4_events/view/search/search_user_view.dart';
import 'package:social_4_events/view/user/user_view.dart';

//Widget che mostra la lista degli utenti che partecipano ad un determinato evento
class EventUsersView extends StatefulWidget {
  static String route = '/event_users_view';
  final EventUsersViewArguments eventUsersViewArguments;
  const EventUsersView({required this.eventUsersViewArguments});

  @override
  State<EventUsersView> createState() => _EventUsersViewState();
}

class _EventUsersViewState extends State<EventUsersView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventUsersBloc>(context).add(EventUsersBlocEventFetch(
        widget.eventUsersViewArguments.event.usersPartecipants));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.red),
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Utenti - ${widget.eventUsersViewArguments.event.name}",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              userListSection(),
            ],
          ),
        ),
      ),
    );
  }

  //Con questa sezione si costruisce la parte dell'app che permette la visualizzazione degli utenti
  //Se non ci sono utenti che partecipano si scrivera il messaggio sottostante
  userListSection() => BlocBuilder<EventUsersBloc, EventUsersBlocState>(
        builder: (context, state) {
          if (state is EventUsersBlocStateLoaded) {
            var users = state.users;
            if (users.isEmpty) {
              return centerMessageSection(
                  "Per questo evento al momento non ci sono utenti partecipanti.");
            } else {
              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(users[index].imageUrl),
                            radius: 23,
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  users[index].username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${users[index].name} ${users[index].surname}",
                                ), //Text(users[index].username),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          } else if (state is EventUsersBlocStateLoading) {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          } else if (state is EventUsersBlocStateError) {
            return centerMessageSection(state.errorMessage);
          } else {
            return centerMessageSection("Errore generico");
          }
        },
      );

  centerMessageSection(String message) => Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                message,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      );
}
