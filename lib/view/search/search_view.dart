import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/user/user_bloc.dart';
import 'package:social_4_events/bloc/user/user_bloc_event.dart';
import 'package:social_4_events/bloc/user/user_bloc_state.dart';
import 'package:social_4_events/cubit/index_tab_cubit.dart';
import 'package:social_4_events/helpers/enums/tab_index_enum.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/search_user_view_arguments.dart';
import 'package:social_4_events/model/user.dart' as model;
import 'package:social_4_events/view/main_view.dart';
import 'package:social_4_events/view/search/search_user_view.dart';
import 'package:social_4_events/view/user/user_view.dart';

class SearchView extends StatefulWidget {
  static String route = '/search_view';
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchTextController = TextEditingController();
  List<model.User>? users = List.empty(growable: true);
  List<model.User> usersView = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(UserBlocEventFetch());
  }

  @override
  Widget build(BuildContext context) {
    //final indexTabCubit = context.watch<IndexTabCubit>();
    return BlocListener<UserBloc, UserBlocState>(
      listener: (context, state) {
        if (state is UserBlocStateLoaded) {
          setState(() {
            users = state.users;
          });
        } else if (state is UserBlocStateError) {
          setState(() {
            users = null;
          });
        }
      },
      child: Scaffold(
        appBar: users != null
            ? AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                title: Container(
                  height: 41,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onChanged: (String value) {
                      setState(() {
                        if (value.isEmpty) {
                          usersView = [];
                        } else {
                          var usersViewTmp = users!.where((user) {
                            final name = user.name.toLowerCase();
                            final surname = user.surname.toLowerCase();
                            final username = user.username.toLowerCase();
                            final input = value.toLowerCase();

                            return name.contains(input) ||
                                surname.contains(input) ||
                                username.contains(input);
                          }).toList();

                          if (usersViewTmp.isEmpty) {
                            usersView = [];
                          } else {
                            usersView = usersViewTmp;
                          }
                        }
                      });
                    },
                    controller: searchTextController,
                    decoration: InputDecoration(
                      hintText: 'Cerca',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              )
            : null,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                if (users != null)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      itemCount: usersView.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print(usersView[index].id);
                            if (FirebaseAuth.instance.currentUser!.uid ==
                                usersView[index].id) {
                              BlocProvider.of<IndexTabCubit>(context)
                                  .setIndexByEnum(TabIndexEnum.Profile);
                            } else {
                              Navigator.of(context).pushNamed(
                                  SearchUserView.route,
                                  arguments: SearchUserViewArguments(
                                      usersView[index].id));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      NetworkImage(usersView[index].imageUrl),
                                  radius: 23,
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        usersView[index].username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${usersView[index].name} ${usersView[index].surname}",
                                      ), //Text(users[index].username),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Text("Errore generico."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
