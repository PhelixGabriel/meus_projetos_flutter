import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=4010bcd7";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}



Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  double dolar = 0;
  double euro = 0;
  double real = 0;
  @override
  Widget build(BuildContext context) {


    final realController = TextEditingController();
    final dolarController = TextEditingController();
    final euroController = TextEditingController();

    void _clearAll(){
      realController.text = "";
      dolarController.text = "";
      euroController.text = "";
    }

    void _realChanged(String text) {
      if(text.isEmpty) {
        _clearAll();
        return;
      }

      double real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
    }

    void _dolarChanged(String text) {
      if(text.isEmpty) {
        _clearAll();
        return;
      }

      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }

    void _euroChanged(String text) {

      if(text.isEmpty) {
        _clearAll();
        return;
      }

      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    }



    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      appBar: AppBar(
        title: Text(" Conversor "),
        leading: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _clearAll();

          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.pinkAccent,
                Colors.orangeAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        shadowColor: Colors.redAccent,
        elevation: 10,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao Carregar Dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                        buildTextField(
                            "Reais", "Reais\$", realController, _realChanged),
                        Divider(),
                        buildTextField(
                            "Dólares", "US\$", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField(
                            "Euros", "€", euroController, _euroChanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function(String) f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: f,
    keyboardType: TextInputType.number,
  );



}
