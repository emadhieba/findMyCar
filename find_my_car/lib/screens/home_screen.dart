import 'package:find_my_car/screens/concat/concatScreen.dart';
import 'package:find_my_car/screens/maps/mapsScreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';

import '../sheard/componant.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';


class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {

    super.initState();
    checkLocationServicesInDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find My Car'),
        actions: [
          IconButton(

            icon:  Icon(Icons.format_list_bulleted),
            onPressed: ()
            {  },),

        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 200,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 110,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          checkLocationServicesInDevice();
                          navigateTo(context,  ConcatScreen(),);

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blueGrey,

                          ) ,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.add_location,
                                size: 56.0,
                                color: Colors.white,
                              ),

                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Concat The Car',
                                style: TextStyle(
                                    color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
           height: 40,
         ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 200,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 110,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          navigateTo(context,  MapsScreen(),);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.blueGrey,
                          ) ,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                size: 56.0,
                                  color: Colors.white,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Find My Car',
                                style: TextStyle(
                                    color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
