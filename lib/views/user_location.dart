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
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : apistate == ApiState.error
        ? Scaffold(
            body: Center(
              child: Text("There is error", style: TextStyle(fontSize: 50)),
            ),
          )
        : Scaffold(
            appBar: AppBar(title: Text("User Location"), centerTitle: true),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(model.name!, style: TextStyle(fontSize: 60)),
                Text(model.sys!.country!, style: TextStyle(fontSize: 60)),
              ],
            ),
          );
  }
}
