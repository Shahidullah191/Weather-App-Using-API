import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_day_35/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 3),()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff182747),
        body: Column(
          children: [
            Container(
              child: Center(
                child: Lottie.asset("assets/animation/weather_icon.json"),
              ),
            ),

            Container(
              alignment: Alignment.center,
                height: 100,
                child: Column(
                  children: [
                    Text("Discover the Weather", style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700)),
                    Text("in Your City", style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700))
                  ],
                ),

            ),
            Container(
                alignment: Alignment.center,
                height: 100,
                child: Column(
                  children: [
                    Text("Get to know your weather maps and", style: TextStyle(color: Colors.white, fontSize: 16,)),
                    Text("rader percipitiation forecast", style: TextStyle(color: Colors.white, fontSize: 16,)),
                  ],
                ),

            ),
          ],
        ),
      ),
    );
  }
}
