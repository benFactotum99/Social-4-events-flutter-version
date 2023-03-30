import 'package:flutter/material.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_location_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_users_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/search_user_view_arguments.dart';
import 'package:social_4_events/view/add/add_event_view.dart';
import 'package:social_4_events/view/home/event_detail_location_view.dart';
import 'package:social_4_events/view/home/event_detail_view.dart';
import 'package:social_4_events/view/home/event_users_view.dart';
import 'package:social_4_events/view/home/home_view.dart';
import 'package:social_4_events/view/login/login_view.dart';
import 'package:social_4_events/view/main_view.dart';
import 'package:social_4_events/view/search/search_user_view.dart';
import 'package:social_4_events/view/search/search_view.dart';
import 'package:social_4_events/view/user/user_view.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  /// pass the required items for the tabs and BottomNavigationBar
  final List<PersistentTabItem> items;
  final Color selectedItemColor;
  final String initialRoute;
  final Route<dynamic> Function(RouteSettings)? onGenerateRoute;

  const PersistentBottomBarScaffold(
      {Key? key,
      required this.items,
      required this.selectedItemColor,
      required this.initialRoute,
      required this.onGenerateRoute})
      : super(key: key);

  @override
  _PersistentBottomBarScaffoldState createState() =>
      _PersistentBottomBarScaffoldState();
}

class _PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// Check if curent tab can be popped
        if (widget.items[_selectedTab].navigatorkey?.currentState?.canPop() ??
            false) {
          widget.items[_selectedTab].navigatorkey?.currentState?.pop();
          return false;
        } else {
          // if current tab can't be popped then use the root navigator
          return true;
        }
      },
      child: Scaffold(
        /// Using indexedStack to maintain the order of the tabs and the state of the
        /// previously opened tab
        body: IndexedStack(
          index: _selectedTab,
          children: widget.items
              .map((page) => Navigator(
                    /// Each tab is wrapped in a Navigator so that naigation in
                    /// one tab can be independent of the other tabs
                    key: page.navigatorkey,
                    initialRoute: widget.initialRoute,
                    onGenerateRoute: widget.onGenerateRoute,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => page.tab)
                      ];
                    },
                  ))
              .toList(),
        ),

        /// Define the persistent bottom bar
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedTab,
          selectedItemColor: widget.selectedItemColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            /// Check if the tab that the user is pressing is currently selected
            if (index == _selectedTab) {
              /// if you want to pop the current tab to its root then use
              widget.items[index].navigatorkey?.currentState
                  ?.popUntil((route) => route.isFirst);

              /// if you want to pop the current tab to its last page
              /// then use
              // widget.items[index].navigatorkey?.currentState?.pop();
            } else {
              setState(() {
                _selectedTab = index;
              });
            }
          },
          items: widget.items
              .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon), label: item.title))
              .toList(),
        ),
      ),
    );
  }
}

/// Model class that holds the tab info for the [PersistentBottomBarScaffold]
class PersistentTabItem {
  final Widget tab;
  final GlobalKey<NavigatorState>? navigatorkey;
  final String title;
  final IconData icon;

  PersistentTabItem(
      {required this.tab,
      this.navigatorkey,
      required this.title,
      required this.icon});
}
