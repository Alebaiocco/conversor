import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=e51dc816";

void main() async{
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.purple,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          hintStyle: TextStyle(color: Colors.purple),
        )),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late double euro;
  late double dolar;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text){
    if(text.isEmpty){
      _clearALL();
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearALL();
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro ).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if(text.isEmpty){
      _clearALL();
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _clearALL(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Conversor de Moeda", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),

        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child : Text('Carregando Dados...',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                )
              );
            default:
              if(snapshot.hasError){
                return Center(
                    child : Text('Erro ao Carregar Dados ...',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 26,
                      ),
                      textAlign: TextAlign.center,
                    )
                );
              }
              else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on, size: 125.0, color: Colors.purple,),
                      Divider(),
                      TextField(
                          controller: realController,
                          decoration: InputDecoration(
                            labelText: "Reais",
                            labelStyle: TextStyle(color: Colors.purple, fontSize: 15),
                            border: OutlineInputBorder(),
                            prefixText: "R\$ ",
                          ),
                          onChanged: _realChanged,
                          keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                          controller: dolarController,
                          decoration: InputDecoration(
                            labelText: "Dólares",
                            labelStyle: TextStyle(color: Colors.purple, fontSize: 15),
                            border: OutlineInputBorder(),
                            prefixText: "US\$ ",
                          ),
                      onChanged: _dolarChanged,
                      keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: euroController,
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(color: Colors.purple, fontSize: 15),
                          border: OutlineInputBorder(),
                          prefixText: "€ ",
                        ),
                        onChanged: _euroChanged,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
