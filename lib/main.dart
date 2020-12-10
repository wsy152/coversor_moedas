import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=424e3f5d';
void main() async {
  print(await getData());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  double dollar;
  double euro;

  void _realChange(String text) {
    double real = double.parse(text);
    dollarController.text = (real / dollar).toStringAsPrecision(4);
    euroController.text = (real / euro).toStringAsPrecision(4);
  }

  void _dollarChange(String text) {}

  void _euroChange(String text) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '\$ Conversor de Moedas \$',
          style: TextStyle(color: Colors.yellow, fontSize: 25),
        ),
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
                  'Carregando dados...',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Contem erros na chamada...',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dollar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 120,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      bildTextField(
                          'Reais', 'R\$', realController, _realChange),
                      SizedBox(
                        height: 20,
                      ),
                      bildTextField(
                          'Dolar', '\$', dollarController, _dollarChange),
                      SizedBox(
                        height: 20,
                      ),
                      bildTextField('Euro ', '\€', euroController, _euroChange),
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

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget bildTextField(
    String text, String prefix, TextEditingController ctl, Function f) {
  return TextField(
    keyboardType: TextInputType.number,
    controller: ctl,
    onChanged: f,
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      fontSize: 25,
      color: Colors.yellow,
    ),
  );
}
