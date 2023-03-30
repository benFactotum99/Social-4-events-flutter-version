import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_4_events/components/custom_button.dart';
import 'package:social_4_events/helpers/view_helpers/arguments/event_detail_location_view_arguments.dart';
import 'package:social_4_events/helpers/view_helpers/map_location.dart';

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
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
