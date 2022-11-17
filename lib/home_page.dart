import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Position position;
  Map<String, dynamic> ?weatherMap;
  Map<String, dynamic> ?forecastMap;

   _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    fetchWeatherData();
  }

  var latitude;
  var longitude;

  fetchWeatherData() async{
    String forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=f92bf340ade13c087f6334ed434f9761";
    String weatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=f92bf340ade13c087f6334ed434f9761";

    var weatherResponse = await http.get(Uri.parse(weatherUrl));
    var forecastResponse = await http.get(Uri.parse(forecastUrl));

    weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponse.body));
    forecastMap = Map<String, dynamic>.from(jsonDecode(forecastResponse.body));

    setState(() {
      print("eeeee${forecastMap!["cod"]}");
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    _determinePosition();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: forecastMap != null
          ? Scaffold(
        body: Stack(
          children: [

            Container(
              child: Lottie.asset("assets/animation/cloudy_weather.json", fit: BoxFit.cover, height: double.infinity, width: double.infinity),
            ),

            Positioned(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              "${Jiffy(DateTime.now()).format("MMM do yy")} , ${Jiffy(DateTime.now()).format("h:mm")}", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                          Text("${weatherMap!["name"]}", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),

                    Container(
                      height: 200,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        //border: Border.all(width: 1),
                        //color: Colors.white.withOpacity(0.1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Lottie.asset("assets/animation/night.json", height: 100),
                              Text(
                                  "${weatherMap!["main"]["temp"]} °",
                                  style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.w700)
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Feels Like ${weatherMap!["main"]["feels_like"]} °", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                                  Text("${weatherMap!["weather"][0]["description"]}", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))
                                ]),
                          ),
                        ],
                      ),
                    ),



                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),

                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(children: [
                          Text(
                              "Humidity ${weatherMap!["main"]["humidity"]}, Pressure ${weatherMap!["main"]["pressure"]}", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                          Text(
                              "Sunrise ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("h:mm a")} , Sunset ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)}").format("h:mm a")}", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("After Two Days Forecast", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700)),
                       SizedBox(height: 10,),

                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                              separatorBuilder: (context, index)=> SizedBox(width: 15,),
                              scrollDirection: Axis.horizontal,
                              itemCount: forecastMap!.length,
                              itemBuilder: (context, index) {
                                var x = forecastMap!["list"][index]["weather"][0]
                                ["icon"];
                                return Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),

                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  width: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          "${Jiffy(forecastMap!["list"][index]["dt_txt"]).format("EEE h:mm")}",style: TextStyle( fontSize: 20, color: Colors.white)),

                                Lottie.asset("assets/animation/mostly_sunny.json", height: 100),

                                      Text(
                                          "${forecastMap!["list"][index]["main"]["temp_min"]}  ${forecastMap!["list"][index]["main"]["temp_max"]} °  ", style: TextStyle( fontSize: 20, color: Colors.white)),

                                      Text(
                                          "${forecastMap!["list"][index]["weather"][0]["description"]}", style: TextStyle( fontSize: 20, color: Colors.white))
                                    ],
                                  ),
                                );
                              }),
                        )

                      ],
                    ),


                  ],
                ),
              ),
            ),
          ],
        )
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
