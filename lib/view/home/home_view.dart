import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_4_events/bloc/event/event_bloc.dart';
import 'package:social_4_events/bloc/event/event_bloc_event.dart';
import 'package:social_4_events/bloc/event/event_bloc_state.dart';
import 'package:social_4_events/helpers/generic_functions_helpers/generic_functions.dart';
import 'package:social_4_events/helpers/singleton/position_singleton.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_view_arguments.dart';
import 'package:social_4_events/view/add/add_event_view.dart';
import 'package:social_4_events/view/home/event_detail_view.dart';
import 'package:social_4_events/view/home/event_pop_up_view.dart';

//Home dell'app in cui si visualizza la mappa del globo con i marker
//che stanno a rappresentare gli eventi creati
class HomeView extends StatefulWidget {
  static String route = '/home_view';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Completer<GoogleMapController> googleMapController = Completer();

  final Set<Marker> googleMapMarkers = {};

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventBloc>(context).add(EventBlocEventFetch());
    initAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        /*bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            color: Colors.grey,
            height: 0.5,
          ),
        ),*/
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
        centerTitle: false,
        title: Text(
          "Social4Events",
          style: TextStyle(
            color: Colors.red,
            //fontWeight: FontWeight.bold,
            fontSize: 33,
            fontFamily: 'Cookie',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_box_outlined,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddEventView.route);
            },
          )
        ],
      ),
      body: BlocBuilder<EventBloc, EventBlocState>(
        builder: (context, state) {
          if (state is EventBlocStateError &&
              PositionSingleton.latLng == null) {
            return Center(
              child: Text(
                "Errore - 505",
                style: TextStyle(fontSize: 24),
              ),
            );
          } else if (state is EventBlocStateLoaded &&
              PositionSingleton.latLng != null) {
            final events = state.events;

            //Con uesto for si cicla gli eventi e ci si creano i marker
            for (var event in events) {
              googleMapMarkers.add(
                Marker(
                  markerId: MarkerId(event.id),
                  position:
                      LatLng(event.locationLatitude, event.locationLongitude),
                  //infoWindow: InfoWindow(title: event.locationName),
                  onTap: () {
                    print(event.id);
                    showDialog(
                      context: context,
                      builder: (BuildContext contextDialog) {
                        return EventPopUpView(
                          event: event,
                          onPressed: () {
                            Navigator.of(contextDialog).pop();
                            Navigator.of(context).pushNamed(
                                EventDetailView.route,
                                arguments: EventDetailViewArguments(event));
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }

            return Stack(
              children: [
                GoogleMap(
                  markers: googleMapMarkers,
                  initialCameraPosition: CameraPosition(
                    target: PositionSingleton
                        .latLng!, //LatLng(37.42796133580664, -122.085749655962),
                    zoom: 15,
                  ),
                  myLocationButtonEnabled: false,
                  onMapCreated: (controller) async {
                    if (!googleMapController.isCompleted) {
                      googleMapController.complete(controller);
                    }
                    final styles = await services.rootBundle
                        .loadString("assets/map_style/google_map_style.json");
                    controller.setMapStyle(styles);
                  },
                ),
                //Text input per il search della località degli eventi
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onFieldSubmitted: (String value) {
                        goToPlace(value);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  //Init per consentire all'app di acquisire (sotto permesso dell'utente)
  //la posizione esatta dell'utente
  void initAsync() async {
    try {
      var position = await determinePosition();
      PositionSingleton.latLng = LatLng(position.latitude, position.longitude);
      //moveToUserPlace(position);
    } catch (error) {
      PositionSingleton.latLng = LatLng(37.42796133580664, -122.085749655962);
      //moveToDefaultPlace();
      print(error);
    }
    setState(() {});
  }

  //Spostamento della camera ad una località conoscendone l'indirizzo
  void goToPlace(String address) async {
    final controller = await googleMapController.future;

    var latLong = await getCoordinates(address);

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latLong['lat'], latLong['lng']),
          zoom: 15,
        ),
      ),
    );
  }

  //Spostamento della camera tramite l'oggetto Position
  void moveToUserPlace(Position position) async {
    final controller = await googleMapController.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  //Spostamento della camera alla posizione di default
  void moveToDefaultPlace() async {
    final controller = await googleMapController.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 15,
        ),
      ),
    );
  }
}
