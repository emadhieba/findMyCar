import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_car/screens/LOGIN/loginScreen.dart';
import 'package:find_my_car/screens/LOGIN/phone_cubit.dart';
import 'package:find_my_car/screens/LOGIN/phone_cubit.dart';
import 'package:find_my_car/sheard/componant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'my_drawer.dart';
 class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> myMarkers = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Location location =  Location();
  LocationData? currentLocation;
  String googleAPiKey = "https://trueway-matrix.p.rapidapi.com/CalculateDrivingMatrix";
  Map<PolylineId, Polyline> polylines = {};
  DatabaseReference ref = FirebaseDatabase.instance.ref('/');

  @override
  void initState() {
    super.initState();
    print('dddd');
    ref.child('GPS').onValue.listen((event) {
      DataSnapshot snap = event.snapshot;
      Map data = snap.value as Map ;
      data['key']=snap.key;
      print(data['Lat']);
      setState(()  {
        if(data != null){
          myMarkers.add(

            Marker (
              markerId: MarkerId('1'),
              position: LatLng(data['Lat'], data['Long']),
              infoWindow: InfoWindow(
                title: 'My car',

              ),

            ),
          );
        }
      });
    });
    getCurentLocation();
    FirebaseFirestore.instance.collection('user').snapshots().listen((event) {
      event.docChanges.forEach((change) {
        setState(() {
          myMarkers.add(
            Marker(
              markerId: MarkerId(change.doc.id),
              position: LatLng(change.doc.data()!['location'].latitude,
                  change.doc.data()!['location'].longitude),
              infoWindow: InfoWindow(
                title: change.doc.data()!['name'].toString(),

              ),

            ),
          );
        });
      });
    });
  }

  void getCurentLocation()async{
    Location location =  Location();
    location.onLocationChanged.listen((LocationData currentLocation) {
      FirebaseFirestore.instance.collection('user').doc('n49tEXsPXmDmNMyJeWT2').set({
        'name':'My phone',
        'location' : GeoPoint(currentLocation.latitude!,currentLocation.longitude!),
      });
    });

  }
  //
  // getDirections() async {
  //   List<LatLng> polylineCoordinates = [];
  //
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     googleAPiKey,
  //     PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
  //     PointLatLng(endLocation.latitude, endLocation.longitude),
  //     travelMode: TravelMode.driving,
  //   );
  //
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   } else {
  //     print(result.errorMessage);
  //   }
  //   addPolyLine(polylineCoordinates);
  // }
  //
  // addPolyLine(List<LatLng> polylineCoordinates) {
  //   PolylineId id = PolylineId("poly");
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.deepPurpleAccent,
  //     points: polylineCoordinates,
  //     width: 8,
  //   );
  //   polylines[id] = polyline;
  //   setState(() {});
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
       backgroundColor: Colors.blueGrey,
        title: const Text('Your Car',
        style: TextStyle(
          color: Colors.white,
          fontSize: 27,
        ),
        ),
        centerTitle: true,

      ),
      drawer: MyDrawer(),
      body: GoogleMap(
        myLocationButtonEnabled: true,
         myLocationEnabled: true,
         zoomControlsEnabled: false,
         mapType: MapType.hybrid,
        initialCameraPosition:
        CameraPosition(
          target: LatLng(30.04167 ,31.23528),
          zoom: 5,
        ),
        onMapCreated:(GoogleMapController googleMapController){
          _controller.complete(googleMapController);
        },

         markers:myMarkers.toSet(),
        polylines: Set<Polyline>.of(polylines.values),


      ),

    );
  }
}


  // getCurentLocation();
//




