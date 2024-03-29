import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/bloc/user_generic/user_generic_bloc.dart';
import 'package:social_4_events/bloc/user_generic/user_generic_bloc_event.dart';
import 'package:social_4_events/bloc/user_generic/user_generic_bloc_state.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/search_user_view_arguments.dart';
import 'package:social_4_events/model/event.dart';
import 'package:social_4_events/view/home/event_detail_view.dart';

//Widget dedicata alla visualizzazione dei dettagli di un utente generico
//e dei suoi eventi, creati e partecipati
//Widget molto simile allo user_view (infatti si ha un po di codice ripetuto
//che con il refactoring si potrebbe togliere), con la differenza che ho come parametro l'id di un generico
//utente selezionato nella search_view
class SearchUserView extends StatefulWidget {
  static String route = '/search_user_view';
  final SearchUserViewArguments searchUserViewArguments;
  const SearchUserView({required this.searchUserViewArguments});

  @override
  State<SearchUserView> createState() => _SearchUserViewState();
}

class _SearchUserViewState extends State<SearchUserView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    BlocProvider.of<UserGenericBloc>(context).add(
        UserGenericBlocEventFetchUserById(
            widget.searchUserViewArguments.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserGenericBloc, UserGenericBlocState>(
        builder: (context, state) {
          if (state is UserGenericBlocStateLoaded) {
            var user = state.user;
            var eventsCreated = state.eventsCreated;
            var eventsPartecipated = state.eventsPartecipated;
            //Ho deciso di utilizzare questo componente per consentire a questo widget di
            //avere uno scroll con una tab bar in cui appena la tab arriva a conttatto
            //con l'app bar loro diventano un'unica cosa con la griglia di immagini che
            //si adatta allo schermo del telefono
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
                      "${user.username}",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
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
                  //Qui ho il componente che consente alla tab bar di collidere con l'appbar
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
          } else if (state is UserGenericBlocStateError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  //Sezione per l'immagine dell'utente, se non è presente la si sostituisce con un'icona
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

  //Sezione per la gestione della griglia degli eventi creati
  eventsCreatedGridSection(List<Event> eventsCreated) => GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: List.generate(
          eventsCreated.length,
          (index) => InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(EventDetailView.route,
                  arguments: EventDetailViewArguments(eventsCreated[index]));
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

  //Sezione per la gestione della griglia degli eventi partecipati
  eventsPartecipatedGridSection(List<Event> eventsPartecipated) =>
      GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: List.generate(
          eventsPartecipated.length,
          (index) => InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(EventDetailView.route,
                  arguments:
                      EventDetailViewArguments(eventsPartecipated[index]));
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

//Classe di supporto al tab bar
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
