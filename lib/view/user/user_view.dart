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

class _UserViewState extends State<UserView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.red),
                elevation: 0,
                centerTitle: false,
                pinned: true,
                title: Text(
                  "Benny",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
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
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(child: SizedBox(height: 25)),
              imageEventSection(),
              SliverToBoxAdapter(child: SizedBox(height: 25)),
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Nome Utente",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Genere",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Nazione",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
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
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20)),
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
              eventsCreated(),
              eventsPartecipated(),
            ],
          ),
        ),
      ),
    );
  }

  imageEventSection() => SliverToBoxAdapter(
        child: InkWell(
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
        ),
      );

  eventsCreated() => GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: List.generate(
          100,
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
      );

  eventsPartecipated() => GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: List.generate(
          100,
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
