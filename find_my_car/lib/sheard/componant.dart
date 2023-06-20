import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

void navigateTo(context,widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);
void navigateAndFinish(context,widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
      (Route<dynamic>route) => false,
);


Future<void> checkLocationServicesInDevice() async {

  Location location = new Location();
  LocationData _location;

  PermissionStatus _permissionGranted;

 bool _serviceEnabled;
  _serviceEnabled = await location.serviceEnabled();

  if(_serviceEnabled)
  {

    _permissionGranted = await location.hasPermission();

    if(_permissionGranted == PermissionStatus.granted)
    {

      _location = await location.getLocation();
      print(_location.latitude.toString() + " " + _location.longitude.toString());


      location.onLocationChanged.listen((LocationData currentLocation) {
        print(currentLocation.latitude.toString() + " " + currentLocation.longitude.toString());
      });

    } else{

      _permissionGranted = await location.requestPermission();

      if(_permissionGranted == PermissionStatus.granted)
      {

        print('user allowed');

      }else{

        SystemNavigator.pop();

      }

    }

  }else{

    _serviceEnabled = await location.requestService();

    if(_serviceEnabled)
    {

      _permissionGranted = await location.hasPermission();

      if(_permissionGranted == PermissionStatus.granted)
      {

        print('user allowed before');

      }else{

        _permissionGranted = await location.requestPermission();

        if(_permissionGranted == PermissionStatus.granted)
        {

          print('user allowed');

        }else{

          SystemNavigator.pop();

        }

      }


    }else{

      SystemNavigator.pop();

    }

  }


}
String? verificationId ;
