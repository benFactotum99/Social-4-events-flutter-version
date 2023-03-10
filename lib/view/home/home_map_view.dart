import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMapView extends StatefulWidget {
  const HomeMapView({super.key});

  @override
  State<HomeMapView> createState() => _HomeMapViewState();
}

class _HomeMapViewState extends State<HomeMapView> {
  final Completer<GoogleMapController> googleMapController = Completer();

  final Set<Marker> googleMapMarkers = {};
  final Set<Circle> googleMapCircles = {};

  @override
  void initState() {
    super.initState();

    setState(() {
      googleMapMarkers.add(
        Marker(
          markerId: MarkerId("google_plex"),
          position: LatLng(37.42796133580664, -122.085749655962),
          infoWindow: InfoWindow(title: "Google Plex"),
        ),
      );

      googleMapCircles.add(
        Circle(
          circleId: CircleId("google_plex"),
          center: LatLng(37.42796133580664, -122.085749655962),
          radius: 500,
          fillColor: Colors.blue.withAlpha(50),
          strokeWidth: 1,
          strokeColor: Colors.blue.withAlpha(200),
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
      ),
      body: GoogleMap(
        markers: googleMapMarkers,
        circles: googleMapCircles,
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
    );
  }
}
