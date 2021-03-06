import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String? _search;
  int _offset = 0;

  // ignore: non_constant_identifier_names
  Future<Map> _getGifs() async {
    http.Response response;
    
    if(_search == null) {
      response = await http.get(Uri(path: "https://api.giphy.com/v1/gifs/trending?api_key=eubLhLmwhWCM3qCA9bhFcj4644v8agyy&limit=20&rating=g"));
    } else {
      response = await http.get(Uri(path: "https://api.giphy.com/v1/gifs/search?api_key=eubLhLmwhWCM3qCA9bhFcj4644v8agyy&q=$_search&limit=20&offset=$_offset&rating=g&lang=en"));
    }

    return json.decode(response.body);
  }

  @override
  void initState() {

    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
