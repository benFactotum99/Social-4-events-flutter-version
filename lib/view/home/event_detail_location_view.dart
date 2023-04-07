import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_4_events/components/custom_button.dart';
import 'package:social_4_events/helpers/generic_functions_helpers/generic_functions.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_location_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/map_location.dart';

//Questo widget serve per la visualizzazione della localita di un evento
//Infatti come parametro viene passato un EventDetialLocationViewArguments
//Contenente un oggetto MapLocation con le coordinate della località dell'evento
class EventDetailLocationView extends StatefulWidget {
  static String route = '/event_detail_location_view';
  final EventDetialLocationViewArguments eventDetialLocationViewArguments;
  const EventDetailLocationView(
      {required this.eventDetialLocationViewArguments});

  @override
  State<EventDetailLocationView> createState() =>
      _EventDetailLocationViewState();
}

class _EventDetailLocationViewState extends State<EventDetailLocationView> {
  final Completer<GoogleMapController> googleMapController = Completer();

  final Set<Marker> googleMapMarkers = {};

  @override
  void initState() {
    super.initState();

    setState(() {
      //Si setta il marker sulla mappa
      googleMapMarkers.add(
        Marker(
          markerId:
              MarkerId(widget.eventDetialLocationViewArguments.location.name),
          position: LatLng(
              widget.eventDetialLocationViewArguments.location.latitude,
              widget.eventDetialLocationViewArguments.location.longitude),
          infoWindow: InfoWindow(
              title: widget.eventDetialLocationViewArguments.location.name),
        ),
      );
    });
  }

  //Metodo utile per lo spostamento della camera in base all'indirizzo digitato
  //dall'utente
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red),
        elevation: 1,
        centerTitle: false,
        title: Text(
          "Località",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      body: Stack(
        children: [
          //Elemento GoogleMap con mappa personalizzata presa da un file
          //Che viene centrata sulla località di appartenenza dell'evento
          GoogleMap(
            markers: googleMapMarkers,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.eventDetialLocationViewArguments.location.latitude,
                  widget.eventDetialLocationViewArguments.location.longitude),
              zoom: 15,
            ),
            myLocationButtonEnabled: false,
            onMapCreated: (controller) async {
              googleMapController.complete(controller);
              final styles = await services.rootBundle
                  .loadString("assets/map_style/google_map_style.json");
              controller.setMapStyle(styles);
            },
          ),
          //Search box che effettua gli spostamenti nella mappa nelle località indicate dall'utente
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
      ),
    );
  }
}
