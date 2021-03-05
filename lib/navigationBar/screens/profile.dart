import 'dart:convert';
import 'dart:io' as io;
import 'dart:async';
import 'package:eralp_software_task/animation.dart';
import 'package:eralp_software_task/changeUserName.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import 'package:eralp_software_task/login.dart';
import 'package:geocoding/geocoding.dart';
// ignore: unused_import
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eralp_software_task/value.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List userInfos = [];
  Position currentPosition;
  String cityName = " ";
  logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getExactLocation();
    // this.getuserNameP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
          gradient: LinearGradient(
            begin: Alignment(-1.0, 0.0),
            end: Alignment(1.0, 0.0),
            colors: [
              const Color(0xfffabd5e),
              const Color(0xfff7b053),
              const Color(0xfff49d42),
              const Color(0xfff3963d),
            ],
            stops: [0.0, 0.232, 0.687, 1.0],
          ),
          title: Text("Profil"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => logoutUser(),
            ),
          ],
        ),
        body: Column(
          children: [
            profilePic(),
            SizedBox(
              height: s.height * .02,
            ),
            profileInfo(),
            SizedBox(
              height: s.height * .2,
            ),
            location(),
          ],
        ),
      ),
    );
  }

  profilePic() {
    Size s = MediaQuery.of(context).size;
    return FadeAnimation(
        1.2,
        Padding(
          padding: EdgeInsets.only(top: s.width * .3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                CircleAvatar(
                    radius: s.width * .20,
                    backgroundColor: Colors.green,
                    backgroundImage: uploadedImage == null
                        ? AssetImage("assets/images/pp.jpg")
                        : FileImage(uploadedImage)),
                Positioned(
                  bottom: -5,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      size: s.width * .1,
                      color: const Color(0xfff3963d),
                    ),
                    onPressed: () => uploadFromCam(),
                  ),
                )
              ]),
            ],
          ),
        ));
  }

  profileInfo() {
    Size s = MediaQuery.of(context).size;
    return FadeAnimation(
      1.2,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                uName,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UNameForm()));
              })
        ],
      ),
    );
  }

  Future uploadFromCam() async {
    final ppic = await ImagePicker().getImage(source: ImageSource.camera);
    if (mounted) {
      setState(() {
        uploadedImage = io.File(ppic.path);
      });
    }
  }

  location() {
    return Container(
      child: Text(cityName),
    );
  }

  getExactLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }

      getAdressFromLatLng();
    });
  }

  getAdressFromLatLng() async {
    try {
      List p = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = p[0];
      if (mounted) {
        setState(() {
          cityName =
              "Konumunuz : ${place.subAdministrativeArea},${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
