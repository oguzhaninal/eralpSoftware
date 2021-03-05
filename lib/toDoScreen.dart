import 'dart:convert';

import 'package:eralp_software_task/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'animation.dart';

class ToDoScreen extends StatefulWidget {
  List items;

  ToDoScreen(this.items);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  TextEditingController t1 = TextEditingController();

  deleteToDoItem(var item) async {
    Map<String, String> headers = {"token": userToken};
    var response = await http.delete(restApiUrl + "/" + item["id"].toString(),
        headers: headers);

    if (response.statusCode == 200) {
      takeToDo();
    }
  }

  takeToDo() async {
    Map<String, String> headers = {"token": userToken};

    var response = await http.get(
      restApiUrl,
      headers: headers,
    );
    if (response.statusCode == 200) {
      var jsonItems = json.decode(response.body);

      if (mounted) {
        setState(() {
          widget.items = jsonItems["body"];
          // itemId = items["${items.id}"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      1.2,
      Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return index == 0
                      ? searchBar(widget.items[index])
                      : getCard(widget.items[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  searchBar(var item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, right: 15, left: 15),
      child: TextFormField(
        controller: t1,
        decoration: InputDecoration(
          hintText: "Aradığınız Görevi Bulun",
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
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            item = item.where((task) {
              var taskTitle = task["name"].toLowerCase();
              return taskTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  getCard(var item) {
    Size s = MediaQuery.of(context).size;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        IconSlideAction(
          caption: "Sil",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => deleteToDoItem(item),
        )
      ],
      child: Card(
        child: ListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: s.width * .06,
                  child: Text(
                    uName[0].toString(),
                    style: TextStyle(
                      // fontSize: s.width * .1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["name"],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    item["date"].toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
