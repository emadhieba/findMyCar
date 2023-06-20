import 'package:find_my_car/screens/home_screen.dart';
import 'package:find_my_car/sheard/componant.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/cupertino.dart';

import '../../sheard/colors.dart';
import '../LOGIN/loginScreen.dart';
import '../maps/mapsScreen.dart';
class BoardingModel {
  final String image;
  final String title;
  final String body;
  BoardingModel({
    required this.image,
    required this.title,
    required this.body,

});
}
class OnBoarding extends StatefulWidget {
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  var boardControler = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'images/gps-3.jpg',
      title: 'GPS',
      body: 'To operate this system, you need to turn on the "GPS" on your phone, and you also need a "find my car" device to connect it to your car'
    ),
    BoardingModel(
        image: 'images/gps-4.jpg',
        title: 'Location',
        body: 'To use this system, you also need to allow "find my car" to access your current phone location'
''    ),
    BoardingModel(
        image: 'images/internet-1.jpg',
        title: 'Internet',
        body: 'To use this system, you also need to be connected to the internet for each tracking of your vehicle'
    ),
  ];

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                onPageChanged: (int index){
                  if(index== boarding.length-1)
                  {
                    setState((){
                      isLast = true;
                    });

                  }else{
                    setState((){
                      isLast = false;
                    });
                  }
                },
                controller: boardControler,
                  itemBuilder: (context,index) => buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                      controller: boardControler,
                      effect:  const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blueGrey,
                      dotWidth: 10,
                      dotHeight: 10,
                      expansionFactor: 3,
                      spacing: 5.0,
                    ),
                    count: boarding.length,
                ),
                Spacer(),
                FloatingActionButton(onPressed: (){
                  if(isLast){
                    navigateAndFinish(context,  LoginScreen(),);
                  }else{
                    boardControler.nextPage(
                      duration: const Duration(milliseconds: 750,),
                      curve: Curves.fastLinearToSlowEaseIn,
                    );
                  }
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                ),
                  backgroundColor:  Colors.blueGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) =>  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Image(
            image: AssetImage('${model.image}'),
          fit: BoxFit.fitWidth,
          height: 100.0,
        ),
      ),
      // SizedBox(
      //   height: 40.0,
      // ),

      Text(
        '${model.title}',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        '${model.body}',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
      // PageView.builder(itemBuilder: (context,index)),
    ],
  );

}
