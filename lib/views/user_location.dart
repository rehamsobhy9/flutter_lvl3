import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lvl3_flutter/helpers/api_state.dart';
import 'package:lvl3_flutter/helpers/location.dart';
import 'package:geolocator/geolocator.dart';

import '../helpers/model.dart';

class user_location extends StatefulWidget {
  const user_location({super.key});

  @override
  State<user_location> createState() => _user_locationState();
}

class _user_locationState extends State<user_location> {
  ApiState apistate = ApiState.none;
  Weatherdata model = Weatherdata();

  String getweatherimage(int id){
      if(id <=32){
        return 'images/thunder.png';
      } else if(id <= 321){
        return 'images/drizzle.png';
      }else if(id <= 531){
        return 'images/rain.png';
      }else if(id <= 622){
        return 'images/snow.png';
      }else if(id <= 781){
        return 'images/tornado.png';
      }else if(id == 800){
        return 'images/clear.png';
      }else{
        return 'images/cloudy.png';
      }
  }

  getweatherdata() async {
    setState(() {
      apistate = ApiState.loading;
    });
    try {
      Position position = await determinePosition();
      final response = await Dio().get(
        "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=eeefc9760fd0e173a321e796e469a2d4",
      );
      setState(() {
        apistate = ApiState.success;
        model = Weatherdata.fromMap(response.data);
      });
    } catch (e) {
      setState(() {
        apistate = ApiState.error;
      });
      Flushbar(
        message: e.toString(),
        icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300]),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
      ).show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getweatherdata();
  }

  @override
  Widget build(BuildContext context) {
    return apistate == ApiState.loading
        ? Scaffold(
            backgroundColor: Color(0xff3A3F54),
            body: Center(
              child: CircularProgressIndicator(color: Colors.white60),
            ),
          )
        : apistate == ApiState.error
        ? Scaffold(
            backgroundColor: Color(0xff3A3F54),
            body: Center(
              child: Text(
                "Error",
                style: TextStyle(fontSize: 60, color: Colors.white60),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Color(0xff3A3F54),
            appBar: AppBar(
              title: Text(
                "User Location",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Color(0xff3A3F54),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    model.name!,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${(model.main!.temp! - 273.15).toStringAsFixed(1)} °",
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image(
                        color: Colors.white60,
                          height: 150,
                          width: 150,
                          image: AssetImage(
                        getweatherimage(model.weather![0].id!)
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    "${model.weather![0].main} in ${model.sys!.country!}",
                    style: TextStyle(fontSize: 30, color: Colors.white60,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    "Lat : ${model.coord!.lat!} -Lon : ${model.coord!.lon!}",
                    style: TextStyle(fontSize: 30, color: Colors.white60,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("Wind Speed",style: TextStyle(fontSize: 25, color: Colors.white60,fontWeight: FontWeight.bold),),
                          Text(
                            (model.wind!.speed!).toString(),
                            style: TextStyle(fontSize: 25, color: Colors.white60,fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("visibility",style: TextStyle(fontSize: 25, color: Colors.white60,fontWeight: FontWeight.bold),),
                          Text(
                            (model.visibility!).toString(),
                            style: TextStyle(fontSize: 25, color: Colors.white60,fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("humidity",style: TextStyle(fontSize: 25, color: Colors.white60,fontWeight: FontWeight.bold),),
                          Text(
                            (model.main!.humidity!).toString(),
                            style: TextStyle(fontSize: 25, color: Colors.white60,fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          );
  }
}
