import 'dart:convert';
import 'package:eralp_software_task/main.dart';
import 'package:eralp_software_task/navigationBar/navigationBar.dart';
import 'package:eralp_software_task/navigationBar/screens/profile.dart';
import 'package:http/http.dart' as http;
import 'package:eralp_software_task/animation.dart';
import 'package:eralp_software_task/textFormField.dart';
import 'package:eralp_software_task/value.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eralp_software_task/login.dart';

class UNameForm extends StatefulWidget {
  @override
  _UNameFormState createState() => _UNameFormState();
}

class _UNameFormState extends State<UNameForm> {
  TextEditingController t1 = TextEditingController();
  String yazi = " ";

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return FadeAnimation(
      1.2,
      SafeArea(
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
            title: Text("Kullanıcı Adını Değiştir"),
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: s.height * .15,
                ),
                text("Yeni Kullanıcı Adınızı Giriniz :"),
                Padding(
                  padding: EdgeInsets.only(
                      left: s.width * .07, right: s.width * .07),
                  child: textField(t1),
                ),
                button(s),
              ],
            ),
          ),
        ),
      ),
    );
  }

  text(String text) {
    return FadeAnimation(
      1.2,
      Padding(
        padding: const EdgeInsets.only(left: 8, top: 8.0, bottom: 8),
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  textField(TextEditingController _controller) {
    return MyTextFormField(
      controller: _controller,
    );
  }

  button(Size s) {
    return Padding(
      padding: EdgeInsets.only(
          top: s.width * .02, left: s.width * .7, right: s.width * .07),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => changeUserName(t1.text),
            child: Container(
              width: s.width * 0.3,
              height: s.width * .15,
              decoration: BoxDecoration(
                color: const Color(0xfff3963d),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16),
                child: Center(
                  child: Text(
                    "Değiştir",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  changeUserName(String newUserName) async {
    Map<String, String> headers = {
      "content-type": "application/json",
      "token": userToken
    };
    final data = jsonEncode({"username": newUserName});
    // ignore: avoid_init_to_null
    var jsonData = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.put(
        "https://aodapi.eralpsoftware.net/user/$userId",
        headers: headers,
        body: data);

    if (response.statusCode == 200) {
      prefs.setString("username", newUserName);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ),
          (Route<dynamic> route) => false);
    }
  }
}
