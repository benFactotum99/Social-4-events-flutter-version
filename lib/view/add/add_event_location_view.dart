import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_4_events/components/custom_button.dart';
import 'package:social_4_events/helpers/generic_functions_helpers/generic_functions.dart';
import 'package:social_4_events/helpers/singleton/position_singleton.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/add_event_location_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/map_location.dart';

//In questo widget faccio apparire la mappa e consento la selezione di una località per un determinato evento
class AddEventLocationView extends StatefulWidget {
  static String route = '/add_event_location_view';
  final AddEventLocationViewArguments addEventLocationViewArguments;

  const AddEventLocationView({required this.addEventLocationViewArguments});

  @override
  State<AddEventLocationView> createState() => _AddEventLocationViewState();
}

class _AddEventLocationViewState extends State<AddEventLocationView> {
  final Completer<GoogleMapController> googleMapController = Completer();

  final Set<Marker> googleMapMarkers = {};

  MapLocation? location = null;

  @override
  void initState() {
    super.initState();
  }

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
          GoogleMap(
            markers: googleMapMarkers,
            initialCameraPosition: CameraPosition(
              target: PositionSingleton
                  .latLng!, //LatLng(37.42796133580664, -122.085749655962),
              zoom: 15,
            ),
            myLocationButtonEnabled: false,
            onMapCreated: (controller) async {
              googleMapController.complete(controller);
              final styles = await services.rootBundle
                  .loadString("assets/map_style/google_map_style.json");
              controller.setMapStyle(styles);
            },
            onTap: (LatLng latLng) async {
              //print("${latLng.latitude} ${latLng.longitude} ");
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  latLng.latitude, latLng.longitude);
              String name = placemarks[0].name!;
              MapLocation location = MapLocation(
                  name: name,
                  latitude: latLng.latitude,
                  longitude: latLng.longitude);
              /*print(
                  "${location.name} ${location.latitude} ${location.longitude}");*/

              setState(() {
                if (googleMapMarkers.isNotEmpty) {
                  googleMapMarkers.clear();
                }

                googleMapMarkers.add(
                  Marker(
                    markerId: MarkerId("google_plex"),
                    position: LatLng(latLng.latitude, latLng.longitude),
                    infoWindow: InfoWindow(title: "Google Plex"),
                  ),
                );

                this.location = location;
              });
            },
          ),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CustomButton(
                onPressed: () {
                  widget.addEventLocationViewArguments
                      .onLocationsUpdated(this.location);
                  Navigator.pop(context);
                },
                colorButton: Colors.red,
                colorText: Colors.white,
                heightButton: 50,
                isLoading: false,
                text: 'Salva',
                widthButton: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
