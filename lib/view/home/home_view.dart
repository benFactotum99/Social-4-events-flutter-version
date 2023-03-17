import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_4_events/bloc/event/event_bloc.dart';
import 'package:social_4_events/bloc/event/event_bloc_event.dart';
import 'package:social_4_events/bloc/event/event_bloc_state.dart';
import 'package:social_4_events/view/add/add_event_view.dart';

class HomeView extends StatefulWidget {
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

    setState(() {
      /*googleMapMarkers.add(
        Marker(
          markerId: MarkerId("google_plex"),
          position: LatLng(37.42796133580664, -122.085749655962),
          infoWindow: InfoWindow(title: "Google Plex"),
        ),
      );*/
    });
  }

  void goToLake() async {
    final controller = await googleMapController.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(37.43296265331129, -122.08832357078792),
          zoom: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Social4Events",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEventView(),
                ),
              );
            },
          )
        ],
      ),
      body: BlocBuilder<EventBloc, EventBlocState>(
        builder: (context, state) {
          if (state is EventBlocStateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventBlocStateLoaded) {
            final events = state.events;

            for (var event in events) {
              googleMapMarkers.add(
                Marker(
                  markerId: MarkerId(event.id),
                  position:
                      LatLng(event.locationLatitude, event.locationLongitude),
                  infoWindow: InfoWindow(title: event.locationName),
                ),
              );
            }

            return GoogleMap(
              markers: googleMapMarkers,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 15,
              ),
              myLocationButtonEnabled: false,
              onMapCreated: (controller) async {
                googleMapController.complete(controller);
                final styles = await services.rootBundle
                    .loadString("assets/map_style/google_map_style.json");
                controller.setMapStyle(styles);
              },
            );
          } else {
            return Center(
              child: Text(
                "Errore - 505",
                style: TextStyle(fontSize: 24),
              ),
            );
          }
        },
      ),
    );
  }
}
