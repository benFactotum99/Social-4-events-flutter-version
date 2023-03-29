import 'package:flutter/material.dart';
import 'package:social_4_events/components/custom_persistent_bottom_bar_menu.dart';
import 'package:social_4_events/view/home/home_view.dart';
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
    );
  }
}
