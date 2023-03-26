import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_event.dart';
import 'package:social_4_events/bloc/authentication/authentication_bloc_state.dart';
import 'package:social_4_events/bloc/event/event_bloc_event.dart';
import 'package:social_4_events/bloc/user/user_bloc.dart';
import 'package:social_4_events/bloc/user/user_bloc_event.dart';
import 'package:social_4_events/bloc/user/user_bloc_state.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/view/add/add_event_view.dart';
import 'package:social_4_events/view/app.dart';
import 'package:social_4_events/view/home/event_detail_view.dart';
import 'package:social_4_events/view/login/login_view.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<UserBloc>(context).add(UserBlocEventUserLoggedFetch());
  }

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
        body: BlocBuilder<UserBloc, UserBlocState>(
          builder: (context, state) {
            if (state is UserBlocStateUserLoggedLoaded) {
              var user = state.user;
              var eventsCreated = state.eventsCreated;
              var eventsPartecipated = state.eventsPartecipated;
              return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.red),
                      elevation: 0,
                      centerTitle: false,
                      pinned: true,
                      title: Text(
                        "🔒 ${user.username}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.add_box_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddEventView(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<AuthenticationBloc>(context).add(
                              AuthenticationBlocEventLogout(),
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 25)),
                    imageEventSection(user.imageUrl),
                    SliverToBoxAdapter(child: SizedBox(height: 25)),
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "${user.name} ${user.surname}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "${user.email}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "${user.gender}, ${user.birthday}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "${user.address}, ${user.district}, ${user.postalCode}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "${user.city}, ${user.nation}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 20)),
                    /*SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: SizedBox(
                          height: 40,
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Info utente'),
                          ),
                        ),
                      ),
                    ),*/
                    //SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverPersistentHeader(
                      delegate: _MyTabBar(
                        TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.red,
                          labelColor: Colors.red,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.article,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Icons.group,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pinned: true,
                      floating: false,
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    eventsCreatedGridSection(eventsCreated),
                    eventsPartecipatedGridSection(eventsPartecipated),
                  ],
                ),
              );
            } else if (state is UserBlocStateUserLoggedLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserBlocStateUserLoggedError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return Center(child: Text("Errore generico."));
            }
          },
        ),
      ),
    );
  }

  imageEventSection(String imageUrl) => SliverToBoxAdapter(
        child: InkWell(
          onTap: () {},
          child: CircleAvatar(
            radius: 110.0,
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            child: imageUrl.isEmpty
                ? Transform.scale(
                    scale: 5, child: Icon(Icons.account_box_rounded))
                : ClipOval(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: 220,
                      height: 220,
                    ),
                  ),
          ),
        ),
      );

  eventsCreatedGridSection(List<Event> eventsCreated) => GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: List.generate(
          eventsCreated.length,
          (index) => InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventDetailView(
                    event: eventsCreated[index],
                  ),
                ),
              );
            },
            child: Container(
              child: eventsCreated[index].imageUrl.isEmpty
                  ? Container(
                      color: Colors.grey,
                      child: Transform.scale(
                        scale: 3,
                        child: Icon(
                          Icons.event,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                image: eventsCreated[index].imageUrl.isEmpty
                    ? null
                    : DecorationImage(
                        image: NetworkImage(eventsCreated[index].imageUrl),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      );

  eventsPartecipatedGridSection(List<Event> eventsPartecipated) =>
      GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: List.generate(
          eventsPartecipated.length,
          (index) => InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventDetailView(
                    event: eventsPartecipated[index],
                  ),
                ),
              );
            },
            child: Container(
              child: eventsPartecipated[index].imageUrl.isEmpty
                  ? Container(
                      color: Colors.grey,
                      child: Transform.scale(
                        scale: 3,
                        child: Icon(
                          Icons.event,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                image: eventsPartecipated[index].imageUrl.isEmpty
                    ? null
                    : DecorationImage(
                        image: NetworkImage(eventsPartecipated[index].imageUrl),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      );
}

class _MyTabBar extends SliverPersistentHeaderDelegate {
  _MyTabBar(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      //height: 20,
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_MyTabBar oldDelegate) {
    return false;
  }
}
