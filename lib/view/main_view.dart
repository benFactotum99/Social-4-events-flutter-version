import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/components/custom_persistent_bottom_bar_menu.dart';
import 'package:social_4_events/cubit/index_tab_cubit.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/add_event_location_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_location_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_users_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/search_user_view_arguments.dart';
import 'package:social_4_events/view/add/add_event_location_view.dart';
import 'package:social_4_events/view/add/add_event_view.dart';
import 'package:social_4_events/view/home/event_detail_location_view.dart';
import 'package:social_4_events/view/home/event_detail_view.dart';
import 'package:social_4_events/view/home/event_users_view.dart';
import 'package:social_4_events/view/home/home_view.dart';
import 'package:social_4_events/view/login/login_view.dart';
import 'package:social_4_events/view/search/search_user_view.dart';
import 'package:social_4_events/view/search/search_view.dart';
import 'package:social_4_events/view/user/user_view.dart';

class MainView extends StatelessWidget {
  static String route = '/main_view';
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final _tab3navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      selectedItemColor: Colors.red,
      items: [
        PersistentTabItem(
          tab: const HomeView(),
          icon: Icons.home,
          title: 'Home',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: const SearchView(),
          icon: Icons.search,
          title: 'Cerca',
          navigatorkey: _tab2navigatorKey,
        ),
        PersistentTabItem(
          tab: UserView(),
          icon: Icons.account_circle,
          title: 'Profilo',
          navigatorkey: _tab3navigatorKey,
        ),
      ],
      initialRoute: LoginView.route,
      onGenerateRoute: (settings) {
        final routes = {
          LoginView.route: (context) => LoginView(),
          UserView.route: (context) => UserView(),
          SearchView.route: (context) => SearchView(),
          SearchUserView.route: (context) => SearchUserView(
                searchUserViewArguments:
                    settings.arguments as SearchUserViewArguments,
              ),
          HomeView.route: (context) => HomeView(),
          MainView.route: (context) => MainView(),
          EventUsersView.route: (context) => EventUsersView(
                eventUsersViewArguments:
                    settings.arguments as EventUsersViewArguments,
              ),
          EventDetailView.route: (context) => EventDetailView(
                eventDetailViewArguments:
                    settings.arguments as EventDetailViewArguments,
              ),
          EventDetailLocationView.route: (context) => EventDetailLocationView(
                eventDetialLocationViewArguments:
                    settings.arguments as EventDetialLocationViewArguments,
              ),
          AddEventView.route: (context) => AddEventView(),
          AddEventLocationView.route: (context) => AddEventLocationView(
                addEventLocationViewArguments:
                    settings.arguments as AddEventLocationViewArguments,
              ),
        };
        return MaterialPageRoute(builder: routes[settings.name]!);
      },
    );
  }
}
