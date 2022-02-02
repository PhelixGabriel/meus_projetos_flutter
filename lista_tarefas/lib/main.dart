import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();

  List _toDoList = [];
   late Map<String, dynamic> _lastRemoved;
   late int _lastRemovedPos;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data!);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);

      _saveData();
    });
  }

  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList.sort((a, b){
        if(a["ok"] && !b["ok"]) return 1;
        else if(!a["ok"] && b["ok"]) return -1;
        else return 0;
      });
    });

    return null;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text("Lista "),
        centerTitle: true,
        gradient: LinearGradient(
          colors: [
            Colors.purpleAccent,
            Colors.deepOrangeAccent,
            Colors.redAccent
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
       Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text("ADD"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                  onPressed: _addToDo,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(onRefresh: _refresh,
               child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: _toDoList.length,
                    itemBuilder: buildItem),),
          ),
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction){
       setState(() {
         _lastRemoved = Map.from(_toDoList[index]);
         _lastRemovedPos = index;
         _toDoList.removeAt(index);

         _saveData();

         final snack = SnackBar(
           content: Text("Tarefa ${_lastRemoved["title"]} removida!"),
           action: SnackBarAction(label: "Desfazer", 
             onPressed: () {
             setState(() {
               _toDoList.insert(_lastRemovedPos, _lastRemoved);
               _saveData();
             });

             },),
           duration: Duration(seconds: 2),
         );

         ScaffoldMessenger.of(context).showSnackBar(snack);

       });

      },
    );
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}