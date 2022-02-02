import 'package:flutter/material.dart';

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
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados!";

  void _resetField(){
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
    });

  }

  void _calculate(){
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      print(imc);
      if(imc < 18.6){
        _infoText = "Abaixo do peso (${imc.toStringAsPrecision(4)})";
      } else if(imc >= 18.6 && imc < 24.9) {
        _infoText = "Peso ideal (${imc.toStringAsPrecision(4)})";
      } else if(imc >= 24.9 && imc < 29.9) {
        _infoText = "Levemente acima do peso(${imc.toStringAsPrecision(4)})";
      } else if(imc >= 29.9 && imc < 34.9){
        _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      } else if(imc >= 34.9 && imc < 39.9) {
        _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      } else if(imc >= 40) {
        _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          IconButton(onPressed: _resetField,
            icon: Icon(Icons.refresh))
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.person_outline,
                  size: 120.0, color: Colors.deepOrangeAccent),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (KG)",
                    labelStyle: TextStyle(color: Colors.deepOrangeAccent)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25.0),
                controller: weightController,
                validator: (value) {
                  if(value!.isEmpty) {
                    return "Insira seu Peso";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Altura (CM)",
                    labelStyle: TextStyle(color: Colors.deepOrangeAccent)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25.0),
                controller: heightController,
                validator: (value) {
                  if(value!.isEmpty){
                    return "Insira sua altura";
                  }
                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Container(
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        _calculate();
                      }
                    },
                    child: const Text(
                      "Calcular",
                      //style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrangeAccent,
                        textStyle: TextStyle(
                          fontSize: 25,
                        )
                    ),
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
