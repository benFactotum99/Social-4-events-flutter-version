import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_4_events/cubit/index_tab_cubit.dart';
import 'package:social_4_events/helpers/enums/tab_index_enum.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  // qui vengono passati i parametri della bottom bar menu permanent
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
    //Nell'init si ha il set del valore di defaul del cubit che setta l'index su Home
    BlocProvider.of<IndexTabCubit>(context).setIndexByEnum(TabIndexEnum.Home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexTabCubit, int>(
      builder: (context, indexPage) {
        return WillPopScope(
          onWillPop: () async {
            // si contolla se il tap corrente può essere cliccato
            if (widget.items[indexPage].navigatorkey?.currentState?.canPop() ??
                false) {
              widget.items[indexPage].navigatorkey?.currentState?.pop();
              return false;
            } else {
              // se il tab non può essere cliccato su va con la root navigation
              return true;
            }
          },
          child: Scaffold(
            // si utilizza un index stack per mantenere l'ordine delle tab e
            // lo stato del tab precedentemente aperto
            body: IndexedStack(
              index: indexPage, //_selectedTab,
              children: widget.items
                  .map((page) => Navigator(
                        // Ogni tab è wrappata in un navigator, quindi la navigazione in ogni
                        // tab può essere indipendente dagli altri tab, ma qui viene centralizzata
                        // la navigazione a delle rotte passate come parametro
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

            // viene definita la persisten bottom bar
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: indexPage,
              selectedItemColor: widget.selectedItemColor,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                /// Check if the tab that the user is pressing is currently selected
                // si controlla se la tab che l'utente sta premendo è quella selezionata
                if (index == indexPage) {
                  widget.items[index].navigatorkey?.currentState
                      ?.popUntil((route) => route.isFirst);

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

/// Modello delle tab info per [PersistentBottomBarScaffold]
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
