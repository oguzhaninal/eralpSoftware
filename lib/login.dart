import 'dart:convert';

import 'package:eralp_software_task/animation.dart';
// ignore: unused_import
import 'package:eralp_software_task/navigationBar/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'navigationBar/navigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'value.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FadeAnimation(
        1.2,
        Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TopText(),
              LoginForm(),
              //   NewUser(),
            ],
          ),
        ),
      ),
    );
  }
}

class TopText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      1.2,
      Padding(
        padding: const EdgeInsets.only(top: 0, right: 50, left: 50, bottom: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Eralp",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: const Color(0xfff3963d),
              ),
            ),
            Text(
              "Software",
              style: TextStyle(
                fontSize: 35,
                color: const Color(0xfffabd5e),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Form(
      child: Padding(
        padding: EdgeInsets.all(s.height * 0.001),
        child: Column(
          children: [
            userNameField(),
            passField(),
            button(),
          ],
        ),
      ),
    );
  }

  userNameField() {
    return FadeAnimation(
      1.2,
      Padding(
        padding: const EdgeInsets.only(top: 15, left: 50, right: 50),
        child: Container(
          child: TextFormField(
            controller: t1,
            decoration: InputDecoration(
              hintText: "Kullanıcı Adınızı Giriniz",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[200],
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  passField() {
    return FadeAnimation(
      1.2,
      Padding(
        padding: const EdgeInsets.only(top: 15, left: 50, right: 50),
        child: Container(
          child: TextFormField(
            controller: t2,
            obscureText: !passwordVisible,
            decoration: InputDecoration(
              hintText: "Şifrenizi Giriniz",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[200],
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(16),
              ),
              suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[400],
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  }),
            ),
          ),
        ),
      ),
    );
  }

  signIn(String username, String password) async {
    final data = jsonEncode({
      "username": username,
      "password": password,
    });
    Map<String, String> headers = {
      "content-type": "application/json",
    };
    // ignore: avoid_init_to_null
    var jsonData = null;
    // ignore: unused_local_variable
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(
      "https://aodapi.eralpsoftware.net/login/apply",
      body: data,
      headers: headers,
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs?.setBool("isLoggedIn", true);
      jsonData = jsonDecode(response.body);

      userId = jsonData["userId"].toString();
      uName = username;
      userToken = jsonData["token"];
      prefs.setString("username", jsonData["username"]).whenComplete(() {
        prefs.setString("userid", jsonData["userid"]).whenComplete(() {
          prefs.setString("token", jsonData["token"]).whenComplete(() {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => NavigationBar(0)));
          });
        });
      });
    }
  }

  button() {
    Size s = MediaQuery.of(context).size;
    return FadeAnimation(
      1.2,
      Padding(
        padding: const EdgeInsets.only(top: 15, left: 50, right: 50),
        child: GestureDetector(
          onTap: () async {
            signIn(t1.text, t2.text);
          },
          child: Container(
            height: s.height * 0.06,
            width: s.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
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
            ),
            child: Center(
              child: Text(
                "Giriş Yap",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
