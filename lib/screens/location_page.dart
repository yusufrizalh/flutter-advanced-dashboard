// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPage extends StatefulWidget {
  LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final Completer<GoogleMapController> mapController = Completer();

  // Kompas Gramedia Jemursari: -7.323957095985872, 112.74126631381598
  // Yello Hotel Jemursari: -7.319344057393113, 112.74941711459948
  // Plasa Marina Surabaya: -7.316158327553281, 112.7485703912201
  static const LatLng sourceLocation =
      LatLng(-7.316158327553281, 112.7485703912201);
  static const LatLng destination =
      LatLng(-7.319344057393113, 112.74941711459948);

  late LocationData currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
    });

    GoogleMapController googleMapController = await mapController.future;

    location.onLocationChanged.listen(
      (newLocation) {
        currentLocation = newLocation;
        // print("currentLocation: " + currentLocation.toString());
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 18,
              target: LatLng(
                newLocation.latitude!,
                newLocation.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    // getCurrentLocation(); // null karena latitude longitude masih kosong
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: sourceLocation,
          zoom: 14,
        ),
        markers: {
          // Marker(
          //   markerId: const MarkerId("currentLocation"),
          //   position: LatLng(
          //     currentLocation.latitude!,
          //     currentLocation.longitude!,
          //   ),
          // ),
          const Marker(markerId: MarkerId("source"), position: sourceLocation),
          const Marker(
              markerId: MarkerId("destination"), position: destination),
        },
        onMapCreated: (mapCtrl) {
          mapController.complete(mapCtrl);
        },
      ),
    );
  }
}
