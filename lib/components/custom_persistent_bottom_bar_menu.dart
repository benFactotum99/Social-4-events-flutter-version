import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/cubit/index_tab_cubit.dart';
import 'package:social_4_events/helpers/enums/tab_index_enum.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  /// pass the required items for the tabs and BottomNavigationBar
  final List<PersistentTabItem> items;
  final Color selectedItemColor;
  final String initialRoute;
  final Route<dynamic> Function(RouteSettings)? onGenerateRoute;

  const PersistentBottomBarScaffold({
    Key? key,
    required this.items,
    required this.selectedItemColor,
    required this.initialRoute,
    required this.onGenerateRoute,
  }) : super(key: key);

  @override
  _PersistentBottomBarScaffoldState createState() =>
      _PersistentBottomBarScaffoldState();
}

class _PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<IndexTabCubit>(context).setIndexByEnum(TabIndexEnum.Home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexTabCubit, int>(
      builder: (context, indexPage) {
        return WillPopScope(
          onWillPop: () async {
            /// Check if curent tab can be popped
            if (widget.items[indexPage].navigatorkey?.currentState?.canPop() ??
                false) {
              widget.items[indexPage].navigatorkey?.currentState?.pop();
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
              index: indexPage, //_selectedTab,
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
              currentIndex: indexPage,
              selectedItemColor: widget.selectedItemColor,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                /// Check if the tab that the user is pressing is currently selected
                if (index == indexPage) {
                  /// if you want to pop the current tab to its root then use
                  widget.items[index].navigatorkey?.currentState
                      ?.popUntil((route) => route.isFirst);

                  /// if you want to pop the current tab to its last page
                  /// then use
                  // widget.items[index].navigatorkey?.currentState?.pop();
                } else {
                  BlocProvider.of<IndexTabCubit>(context).setIndex(index);
                }
              },
              items: widget.items
                  .map((item) => BottomNavigationBarItem(
                      icon: Icon(item.icon), label: item.title))
                  .toList(),
            ),
          ),
        );
      },
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
