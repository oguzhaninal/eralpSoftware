import 'dart:convert';

import 'package:eralp_software_task/animation.dart';
// ignore: unused_import
import 'package:eralp_software_task/main.dart';
import 'package:eralp_software_task/value.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import 'navigationBar/navigationBar.dart';

class FormToDO extends StatefulWidget {
  @override
  _FormToDOState createState() => _FormToDOState();
}

class _FormToDOState extends State<FormToDO> {
  TextEditingController t1 = TextEditingController();
  DateTime selectedDate;
  TimeOfDay selectedTime;
  String hour;
  String minute;
  bool isPassword = true;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
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
        title: Text("Görev Oluşturun"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: s.height * .2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FadeAnimation(
                  1.2,
                  TextFormField(
                    controller: t1,
                    decoration: InputDecoration(
                        hintText: "Görev Giriniz",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(16),
                        )),
                  ),
                ),
              ),
              text("Tarih ve Saat Seçiniz : "),
              timePicker(s),
              SizedBox(
                height: s.height * .01,
              ),
              timeOfDayPicker(s),
              SizedBox(
                height: s.height * .1,
              ),
              button(),
            ],
          ),
        ),
      ),
    );
  }

  timePicker(Size s) {
    return FadeAnimation(
      1.2,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              selectDate(); // Refer step 3
            },
            child: Container(
                height: s.height * 0.060,
                width: s.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment(1.0, 0.0),
                    end: Alignment(-1.0, 0.0),
                    colors: [
                      const Color(0xfffabd5e),
                      const Color(0xfff7b053),
                      const Color(0xfff49d42),
                      const Color(0xfff3963d)
                    ],
                    stops: [0.0, 0.232, 0.687, 1.0],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Başlangıç Tarihi',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Container(
            height: s.height * 0.060,
            width: s.width * 0.35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xfff3963d),
                )),
            child: Center(
              child: Text(
                selectedDate == null
                    ? "Seçtiğiniz Tarih"
                    : "${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year} ",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  timeOfDayPicker(Size s) {
    return FadeAnimation(
      1.2,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              selectTime(); // Refer step 3
            },
            child: Container(
                height: s.height * 0.060,
                width: s.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment(1.0, 0.0),
                    end: Alignment(-1.0, 0.0),
                    colors: [
                      const Color(0xfffabd5e),
                      const Color(0xfff7b053),
                      const Color(0xfff49d42),
                      const Color(0xfff3963d)
                    ],
                    stops: [0.0, 0.232, 0.687, 1.0],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Başlangıç Tarihi',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Container(
            height: s.height * 0.060,
            width: s.width * 0.35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xfff3963d),
                )),
            child: Center(
              child: Text(
                selectedTime == null
                    ? "Seçtiğiniz Saat"
                    : "${selectedTime.hour} : ${selectedTime.minute} ",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  selectTime() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      hour = selectedTime.hour.toString();
      minute = selectedTime.minute.toString();
    }
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

  button() {
    Size s = MediaQuery.of(context).size;
    return FadeAnimation(
      1.2,
      Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: s.width * .3,
              height: s.width * .1,
              child: FlatButton(
                onPressed: () => createToDo(
                  t1.text,
                  selectedDate,
                  hour + minute,
                ),
                child: Text(
                  "Ekle",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  createToDo(dynamic toDoName, dynamic date, String timeOfDay) async {
    final data = jsonEncode(
        {"name": toDoName, "date": date.toIso8601String() + timeOfDay});
    Map<String, String> headers = {
      "content-type": "application/json",
      "token": userToken
    };
    var jsonData = null;
    var response = await http.post(restApiUrl, body: data, headers: headers);

    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationBar(0),
          ),
          (Route<dynamic> route) => false);
    }
  }
}
