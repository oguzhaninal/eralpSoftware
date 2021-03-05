import 'dart:convert';

import 'package:eralp_software_task/animation.dart';
import 'package:eralp_software_task/login.dart';
// ignore: unused_import
import 'package:eralp_software_task/main.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../../value.dart';
import 'package:eralp_software_task/forms.dart';
import 'package:eralp_software_task/toDoScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = ScrollController();

  List toDoList = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initStat
    this.takeToDo();
    super.initState();
  }

  takeToDo() async {
    Map<String, String> headers = {"token": userToken};

    var response = await http.get(
      restApiUrl,
      headers: headers,
    );
    if (response.statusCode == 200) {
      var items = json.decode(response.body);

      if (mounted) {
        setState(() {
          toDoList = items["body"];
          // itemId = items["${items.id}"];
          isLoading = false;
        });
      }
    }
  }

  creatToDo() async {}
  @override
  Widget build(BuildContext context) {
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
          title: Text("Yapılacaklar"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => FormToDO()));
          },
          backgroundColor: const Color(0xfff3963d),
          child: Icon(Icons.add),
        ),
        body: ToDoScreen(toDoList),
      ),
    );
  }
}
