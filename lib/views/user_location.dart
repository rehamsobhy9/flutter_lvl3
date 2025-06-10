import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lvl3_flutter/helpers/api_state.dart';
import 'package:lvl3_flutter/helpers/location.dart';
import 'package:geolocator/geolocator.dart';

class user_location extends StatefulWidget {
  const user_location({super.key});

  @override
  State<user_location> createState() => _user_locationState();
}

class _user_locationState extends State<user_location> {
  String name = '';
  ApiState apistate = ApiState.none;

  getweatherdata() async {
    setState(() {
      apistate = ApiState.loading;
    });
    Position position = await determinePosition();
    LocationPermission permission = await Geolocator.requestPermission();
    final response = await Dio().get(
      "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=eeefc9760fd0e173a321e796e469a2d4",
    );
    setState(() {
      apistate = ApiState.success;
    });
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
        : Scaffold(
            appBar: AppBar(title: Text("User Location"), centerTitle: true),
            body: Center(child: Text(name)),
          );
  }
}
